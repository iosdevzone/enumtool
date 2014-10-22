# enumtool

A command line tool to wrap Cocoa constants in Swift enums.

## Usage Example

Recently I was working on some code that used the Keychain, part of the Security framework. I changed into the Headers directory of the Security framework and used the following commands to extract a subset of the constants (the valid values for the kSecAttrAccessible attribute)from that file.

```bash
grep '^extern CFTypeRef kSecAttrAccessible' SecItem.h | awk '{ print $3; }' > ~/Documents/src/enumtool/demo/SecAttrAcessible.txt
```

I edit the file to remove `kSecAttrAccessible` attribute itself, and then I ran `enumtool` as follows.

```bash
enumtool -i SecAttrAccessible.txt -n Accessible -r String -o Accessible.swift
```

The result was the following Swift file.

```swift
public enum Accessible : RawRepresentable, Printable {
	case , WhenUnlocked, AfterFirstUnlock, Always, WhenPasscodeSetThisDeviceOnly, WhenUnlockedThisDeviceOnly, AfterFirstUnlockThisDeviceOnly, AlwaysThisDeviceOnly
	
	public static let allValues: [Accessible] = [, WhenUnlocked, AfterFirstUnlock, Always, WhenPasscodeSetThisDeviceOnly, WhenUnlockedThisDeviceOnly, AfterFirstUnlockThisDeviceOnly, AlwaysThisDeviceOnly]
	
	public init?(rawValue: String) {
		if rawValue == String(kSecAttrAccessible) {
			self = 
		}
		else if rawValue == String(kSecAttrAccessibleWhenUnlocked) {
			self = WhenUnlocked
		}
		else if rawValue == String(kSecAttrAccessibleAfterFirstUnlock) {
			self = AfterFirstUnlock
		}
		else if rawValue == String(kSecAttrAccessibleAlways) {
			self = Always
		}
		else if rawValue == String(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly) {
			self = WhenPasscodeSetThisDeviceOnly
		}
		else if rawValue == String(kSecAttrAccessibleWhenUnlockedThisDeviceOnly) {
			self = WhenUnlockedThisDeviceOnly
		}
		else if rawValue == String(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly) {
			self = AfterFirstUnlockThisDeviceOnly
		}
		else if rawValue == String(kSecAttrAccessibleAlwaysThisDeviceOnly) {
			self = AlwaysThisDeviceOnly
		}
		else {
			return nil
		}
	}
	
	public var rawValue: String {
		switch self {
			case : return String(kSecAttrAccessible)
			case WhenUnlocked: return String(kSecAttrAccessibleWhenUnlocked)
			case AfterFirstUnlock: return String(kSecAttrAccessibleAfterFirstUnlock)
			case Always: return String(kSecAttrAccessibleAlways)
			case WhenPasscodeSetThisDeviceOnly: return String(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly)
			case WhenUnlockedThisDeviceOnly: return String(kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
			case AfterFirstUnlockThisDeviceOnly: return String(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)
			case AlwaysThisDeviceOnly: return String(kSecAttrAccessibleAlwaysThisDeviceOnly)
		}
	}
	
	public var description : String {
		switch self {
		case : return ""
		case WhenUnlocked: return "WhenUnlocked"
		case AfterFirstUnlock: return "AfterFirstUnlock"
		case Always: return "Always"
		case WhenPasscodeSetThisDeviceOnly: return "WhenPasscodeSetThisDeviceOnly"
		case WhenUnlockedThisDeviceOnly: return "WhenUnlockedThisDeviceOnly"
		case AfterFirstUnlockThisDeviceOnly: return "AfterFirstUnlockThisDeviceOnly"
		case AlwaysThisDeviceOnly: return "AlwaysThisDeviceOnly"
		}
	}
}

```
