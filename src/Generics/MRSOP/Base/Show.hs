{-# LANGUAGE RankNTypes           #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE GADTs                #-}
{-# LANGUAGE TypeOperators        #-}
{-# LANGUAGE DataKinds            #-}
{-# LANGUAGE PolyKinds            #-}
{-# LANGUAGE ScopedTypeVariables  #-}
{-# LANGUAGE TypeApplications     #-}
-- |Implements a rudimentary show instance for our representations.
--  We keep this isolated because the instance for @Show (Rep ki phi code)@
--  requires undecidable instances. Isolating this allows us to turn on this
--  extension for this module only.
module Generics.MRSOP.Base.Show where

import Generics.MRSOP.Base.NS
import Generics.MRSOP.Base.NP
import Generics.MRSOP.Base.Universe
import Generics.MRSOP.Util

-- https://stackoverflow.com/questions/9082642/implementing-the-show-class
{-instance (Show (fam k)) => Show (NA ki fam (I k)) where
  showsPrec p (NA_I v) = showParen (p > 10) $ showString "I " . showsPrec 11 v
instance (Show (ki  k)) => Show (NA ki fam (K k)) where
  showsPrec p (NA_K v) = showParen (p > 10) $ showString "K " . showsPrec 11 v

instance Show (NP p '[]) where
  show NP0 = "NP0"
instance (Show (p x), Show (NP p xs)) => Show (NP p (x : xs)) where
  showsPrec p (v :* vs)
    = let consPrec = 5
       in showParen (p > consPrec)
        $ showsPrec (consPrec + 1) v . showString " :* " . showsPrec consPrec vs

instance Show (NS p '[]) where
  show _ = error "This code is unreachable"
instance (Show (p x), Show (NS p xs)) => Show (NS p (x : xs)) where
  showsPrec p (Here  x) = showParen (p > 10) $ showString "H " . showsPrec 11 x
  showsPrec p (There x) = showString "T " . showsPrec p x

-- TODO:
-- This needs undecidable instances. We don't like undecidable instances
instance Show (NS (PoA ki phi) code) => Show (Rep ki phi code) where
  show (Rep x) =
-}


instance (Show1 phi, Show1 ki) => Show (NA ki (AnnFix ki codes phi) a) where
  show = showNA

showNA :: (Show1 phi, Show1 ki) => NA ki (AnnFix ki codes phi) a -> String
showNA (NA_I i) = "(NA_I " ++ showFix i ++ ")"
showNA (NA_K k) = "(NA_K " ++ show1 k ++ ")"

instance (Show1 phi, Show1 ki) => Show (PoA ki (AnnFix ki codes phi) xs) where
  show = showNP

showNP :: (Show1 phi, Show1 ki) => PoA ki (AnnFix ki codes phi) xs -> String
showNP NP0 = "NP0"
showNP (a :* b) = showNA a ++ " :* " ++ showNP b

instance (Show1 phi, Show1 ki) => Show (Rep ki (AnnFix ki codes phi) xs) where
  show = showRep
  
showRep :: (Show1 phi, Show1 ki) => Rep ki (AnnFix ki codes phi) xs -> String
showRep x =
  case sop x of
    Tag c poa -> 
      "(" ++ show c ++ " " ++ showNP poa ++ ")"
   

instance (Show1 phi, Show1 ki) => Show (AnnFix ki codes phi ix) where
  show = showFix

showFix :: (Show1 phi, Show1 ki) => AnnFix ki codes phi ix -> String
showFix (AnnFix a x) = "(" ++ show1 a ++  " " ++ showRep x  ++ ")"

