!classDefinition: #I category: 'Numeros Naturales'!
DenotativeObject subclass: #I
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numeros Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'I class' category: 'Numeros Naturales'!
I class
	instanceVariableNames: ''!

!I class methodsFor: 'as yet unclassified' stamp: 'GRC 8/27/2021 16:32:08'!
* unNatural

	^unNatural! !

!I class methodsFor: 'as yet unclassified' stamp: 'GRC 8/26/2021 21:14:03'!
+ unNatural

	^unNatural next! !

!I class methodsFor: 'as yet unclassified' stamp: 'GRC 8/30/2021 15:15:40'!
- unNatural

	^self error: self descripcionDeErrorDeNumerosNegativosNoSoportados! !

!I class methodsFor: 'as yet unclassified' stamp: 'GRC 8/27/2021 16:42:06'!
/ unNatural

	unNatural = self ifTrue: [^self].
	self error: self descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor! !

!I class methodsFor: 'as yet unclassified' stamp: 'GRC 8/27/2021 17:00:23'!
> unNatural

	^false! !

!I class methodsFor: 'as yet unclassified' stamp: 'GRC 8/27/2021 16:42:46'!
descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor

	^'No se puede dividir por un numero mayor'! !

!I class methodsFor: 'as yet unclassified' stamp: 'GRC 8/30/2021 15:16:14'!
descripcionDeErrorDeNumerosNegativosNoSoportados

	^'Error numeros negativos no soportados'.! !

!I class methodsFor: 'as yet unclassified' stamp: 'GRC 8/27/2021 17:16:30'!
divideA: unNatural

	^unNatural! !

!I class methodsFor: 'as yet unclassified' stamp: 'GRC 8/26/2021 20:43:13'!
next

	^II! !

!I class methodsFor: 'as yet unclassified' stamp: 'GRC 8/27/2021 16:30:10'!
restarA: unNatural

	^unNatural previous! !


!classDefinition: #II category: 'Numeros Naturales'!
DenotativeObject subclass: #II
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numeros Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'II class' category: 'Numeros Naturales'!
II class
	instanceVariableNames: 'next previous'!

!II class methodsFor: 'as yet unclassified' stamp: 'GRC 8/27/2021 16:34:54'!
* unNatural

	^unNatural + (unNatural * self previous)! !

!II class methodsFor: 'as yet unclassified' stamp: 'GRC 8/26/2021 21:20:31'!
+ unNatural

	^self previous + unNatural next

	! !

!II class methodsFor: 'as yet unclassified' stamp: 'GRC 8/27/2021 16:27:49'!
- unNatural

	^unNatural restarA: self! !

!II class methodsFor: 'as yet unclassified' stamp: 'GRC 8/27/2021 17:07:01'!
/ unNatural

	unNatural = self ifTrue: [^I].
	unNatural > self ifTrue: [^ self error: self descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor].
	^unNatural divideA: self.! !

!II class methodsFor: 'as yet unclassified' stamp: 'GRC 8/27/2021 17:00:18'!
> unNatural

	unNatural = I ifTrue: [^true].
	^self previous > unNatural previous! !

!II class methodsFor: 'as yet unclassified' stamp: 'GRC 8/27/2021 16:54:53'!
descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor

	^'Error no se puede dividir por un numero mayor'! !

!II class methodsFor: 'as yet unclassified' stamp: 'GRC 9/1/2021 14:17:52'!
divideA: unNatural

	self = unNatural ifTrue: [^I].
	self > (unNatural - self) ifTrue: [^I].
	^I + (self divideA: unNatural - self)
	! !

!II class methodsFor: 'as yet unclassified' stamp: 'GRC 9/1/2021 14:20:59'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := III.
	previous := I.! !

!II class methodsFor: 'as yet unclassified' stamp: 'GRC 8/26/2021 21:23:47'!
next

	next ifNotNil:[^next].
	next _ II createChildNamed: self name, 'I'.
	next previous: self.
	^next! !

!II class methodsFor: 'as yet unclassified' stamp: 'GRC 8/26/2021 21:22:04'!
previous
	
	^previous! !

!II class methodsFor: 'as yet unclassified' stamp: 'GRC 8/26/2021 21:29:36'!
previous: unNatural
	
	previous _ unNatural! !

!II class methodsFor: 'as yet unclassified' stamp: 'GRC 8/31/2021 12:02:59'!
restarA: unNatural

	^(self - I) restarA: (unNatural - I).! !


!classDefinition: #III category: 'Numeros Naturales'!
II subclass: #III
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numeros Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'III class' category: 'Numeros Naturales'!
III class
	instanceVariableNames: ''!

!III class methodsFor: 'as yet unclassified' stamp: 'GRC 9/1/2021 14:20:59'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := IIII.
	previous := II.! !


!classDefinition: #IIII category: 'Numeros Naturales'!
II subclass: #IIII
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numeros Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IIII class' category: 'Numeros Naturales'!
IIII class
	instanceVariableNames: ''!

!IIII class methodsFor: 'as yet unclassified' stamp: 'GRC 9/1/2021 14:20:59'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := IIIII.
	previous := III.! !


!classDefinition: #IIIII category: 'Numeros Naturales'!
II subclass: #IIIII
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numeros Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IIIII class' category: 'Numeros Naturales'!
IIIII class
	instanceVariableNames: ''!

!IIIII class methodsFor: 'as yet unclassified' stamp: 'GRC 9/1/2021 14:20:59'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := IIIIII.
	previous := IIII.! !


!classDefinition: #IIIIII category: 'Numeros Naturales'!
II subclass: #IIIIII
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numeros Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IIIIII class' category: 'Numeros Naturales'!
IIIIII class
	instanceVariableNames: ''!

!IIIIII class methodsFor: 'as yet unclassified' stamp: 'GRC 9/1/2021 14:20:59'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := IIIIIII.
	previous := IIIII.! !


!classDefinition: #IIIIIII category: 'Numeros Naturales'!
II subclass: #IIIIIII
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numeros Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IIIIIII class' category: 'Numeros Naturales'!
IIIIIII class
	instanceVariableNames: ''!

!IIIIIII class methodsFor: 'as yet unclassified' stamp: 'GRC 9/1/2021 14:20:59'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := IIIIIIII.
	previous := IIIIII.! !


!classDefinition: #IIIIIIII category: 'Numeros Naturales'!
II subclass: #IIIIIIII
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numeros Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IIIIIIII class' category: 'Numeros Naturales'!
IIIIIIII class
	instanceVariableNames: ''!

!IIIIIIII class methodsFor: 'as yet unclassified' stamp: 'GRC 9/1/2021 14:20:59'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := IIIIIIIII.
	previous := IIIIIII.! !


!classDefinition: #IIIIIIIII category: 'Numeros Naturales'!
II subclass: #IIIIIIIII
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numeros Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IIIIIIIII class' category: 'Numeros Naturales'!
IIIIIIIII class
	instanceVariableNames: ''!

!IIIIIIIII class methodsFor: 'as yet unclassified' stamp: 'GRC 9/1/2021 14:20:59'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := IIIIIIIIII.
	previous := IIIIIIII.! !


!classDefinition: #IIIIIIIIII category: 'Numeros Naturales'!
II subclass: #IIIIIIIIII
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numeros Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IIIIIIIIII class' category: 'Numeros Naturales'!
IIIIIIIIII class
	instanceVariableNames: ''!

!IIIIIIIIII class methodsFor: 'as yet unclassified' stamp: 'GRC 9/1/2021 14:20:59'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := IIIIIIIIIII.
	previous := IIIIIIIII.! !


!classDefinition: #IIIIIIIIIII category: 'Numeros Naturales'!
II subclass: #IIIIIIIIIII
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numeros Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IIIIIIIIIII class' category: 'Numeros Naturales'!
IIIIIIIIIII class
	instanceVariableNames: ''!

!IIIIIIIIIII class methodsFor: 'as yet unclassified' stamp: 'GRC 9/1/2021 14:20:59'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := nil.
	previous := IIIIIIIIII.! !

II initializeAfterFileIn!
III initializeAfterFileIn!
IIII initializeAfterFileIn!
IIIII initializeAfterFileIn!
IIIIII initializeAfterFileIn!
IIIIIII initializeAfterFileIn!
IIIIIIII initializeAfterFileIn!
IIIIIIIII initializeAfterFileIn!
IIIIIIIIII initializeAfterFileIn!
IIIIIIIIIII initializeAfterFileIn!