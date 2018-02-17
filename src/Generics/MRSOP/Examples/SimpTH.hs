{-# LANGUAGE TypeApplications        #-}
{-# LANGUAGE RankNTypes              #-}
{-# LANGUAGE FlexibleContexts        #-}
{-# LANGUAGE FlexibleInstances       #-}
{-# LANGUAGE GADTs                   #-}
{-# LANGUAGE TypeOperators           #-}
{-# LANGUAGE DataKinds               #-}
{-# LANGUAGE PolyKinds               #-}
{-# LANGUAGE ScopedTypeVariables     #-}
{-# LANGUAGE FunctionalDependencies  #-}
{-# LANGUAGE TemplateHaskell         #-}
{-# LANGUAGE LambdaCase              #-}
{-# LANGUAGE PatternSynonyms         #-}
module Generics.MRSOP.Examples.SimpTH where

import Data.Function (on)

import Generics.MRSOP.Base
import Generics.MRSOP.Opaque
import Generics.MRSOP.Util

import Generics.MRSOP.TH

import Control.Monad
import Control.Monad.State

-- * Simple IMPerative Language:

data Stmt var
  = SAssign var (Exp var)
  | SIf     (Exp var) (Stmt var) (Stmt var)
  | SSeq    (Stmt var) (Stmt var)
  | SReturn (Exp var)
  | SDecl (Decl var)
  | SSkip

data Decl var
  = DVar var
  | DFun var var (Stmt var)

data Exp var
  = EVar  var
  | ECall var (Exp var)
  | EAdd (Exp var) (Exp var)
  | ESub (Exp var) (Exp var)
  | ELit Int

deriveFamily [t| Stmt String |]

pattern Decl_ = SS (SS SZ)
pattern Exp_  = SS SZ
pattern Stmt_ = SZ

pattern SAssign_ v e = Tag CZ (NA_K v :* NA_I e :* NP0)

pattern DVar_ v     = Tag CZ (NA_K v :* NP0)
pattern DFun_ f x s = Tag (CS CZ) (NA_K f :* NA_K x :* NA_I s :* NP0)

pattern EVar_ v    = Tag CZ      (NA_K v :* NP0)
pattern ECall_ f x = Tag (CS CZ) (NA_K f :* NA_I x :* NP0)

type FIX = Fix Singl CodesStmtString

-- * Alpha Equality Functionality

-- | Scoped name equivalences
type ScopedEqvs = [[ (String , String) ]]

type AlphaDEq = State ScopedEqvs

-- Adds a new scope
newScope :: AlphaDEq ()
newScope = modify ([]:)

-- Adds a new name eqv on the current scope.
addEqv :: String -> String -> AlphaDEq ()
addEqv n m
  | m /= n    = modify (\(x:xs) -> ((n , m):x):xs)
  | otherwise = return ()

-- are two names referring to the same variable?
isEqv :: String -> String -> AlphaDEq Bool
isEqv n m
  | n == m    = return True
  | otherwise = get >>= return . eqv n m
  where
    eqv n m []     = False
    eqv n m (s:ss)
      | n `elem` (map fst s) = (n , m) `elem` s
      | otherwise            = eqv n m ss

alphaEq :: Decl String -> Decl String -> Bool
alphaEq = (galphaEq Decl_) `on` (deep @FamStmtString)
  where
    -- Generic programming boilerplate;
    -- could be removed. WE are just passing SNat
    -- and Proxies around.
    galphaEq :: forall iy . (IsNat iy)
             => SNat iy -> FIX iy -> FIX iy -> Bool
    galphaEq iy x y = evalState (galphaEq' iy x y) [[]]

    galphaEqT :: forall iy . (IsNat iy)
              => FIX iy -> FIX iy -> AlphaDEq Bool
    galphaEqT x y = galphaEq' (getSNat' @iy) x y
    
    galphaEq' :: forall iy . (IsNat iy)
              => SNat iy -> FIX iy -> FIX iy -> AlphaDEq Bool
    galphaEq' iy (Fix x)
      = maybe (return False) (go iy) . zipRep x . unFix

    unSString :: Singl k -> String
    unSString (SString s) = s

    -- Performs one default ste by eliminating the topmost Rep
    -- using galphaEqT on the recursive positions and isEqv
    -- on the atoms.
    step = elimRepM (return . uncurry' eqSingl)
                    (uncurry' galphaEqT)
                    (return . and)

    -- The actual important 'patterns'; everything
    -- else is done by 'step'.
    go :: forall iy
        . SNat iy
       -> Rep (Singl :*: Singl) (FIX :*: FIX)
              (Lkup iy CodesStmtString)
       -> AlphaDEq Bool
    go Stmt_ x
      = case sop x of
          SAssign_ (SString v1 :*: SString v2) e1e2
            -> addEqv v1 v2 >> uncurry' (galphaEq' Exp_) e1e2
          otherwise
            -> step x
    go Decl_ x
      = case sop x of
          DVar_ (SString v1 :*: SString v2)
            -> addEqv v1 v2 >> return True
          DFun_ (SString f1 :*: SString f2) (SString x1 :*: SString x2) s
            -> addEqv f1 f2 >> addEqv x1 x2 >> uncurry' galphaEqT s
          _ -> step x
    go Exp_ x
      = case sop x of
          EVar_ v -> uncurry' (isEqv `on` unSString) v
          ECall_ (SString f1 :*: SString f2) e
            -> isEqv f1 f2 >> uncurry' galphaEqT e
          _ -> step x 
    go _ x = step x


{- EXAMPLE

decl fib(n):
  aux = fib(n-1) + fib(n-2);
  return aux;

is alpha eq to

decl fib(x):
  r = fib(x-1) + fib(x-2);
  return r;
-}

test1 :: String -> String -> String -> Decl String
test1 fib n aux = DFun fib n
      $ (SAssign aux (EAdd (ECall fib (ESub (EVar n) (ELit 1)))
                             (ECall fib (ESub (EVar n) (ELit 2)))))
      `SSeq` (SReturn (EVar aux))

test2 :: String -> String -> String -> Decl String
test2 fib n aux = DFun fib n
      $ (SAssign aux (EAdd (ECall fib (ESub (EVar n) (ELit 2)))
                           (ECall fib (ESub (EVar n) (ELit 1)))))
      `SSeq` (SReturn (EVar aux))


