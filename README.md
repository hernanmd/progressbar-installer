## Description

Automatically add progress bar to iterator sends in client classes. This utility is provided to have feedback from the system without the need to change your 20 iterators in a group of client classes where you need to see progress on evaluation.

For example doing:

```smalltalk
SmalltalkImage setDisplayProgressTo: MyClass.
SmalltalkImage setDisplayProgressTo: MyPackage.
```

and then having all enumeration messages sent in MyClass or MyPackage with a progress bar. These iterators could be mapped:

```
collect:
collect:as:
collect:into:
collect:thenDo:
select:
select:as:
select:thenDo:
select:thenCollect:as:
```

See http://forum.world.st/displayingProgress-on-demand-td4865623.html for details

## Usage

```smalltalk
ProgressBarInstaller installOnMethod: SequenceableCollection >> #tokenizeWithoutStopwords.
```
