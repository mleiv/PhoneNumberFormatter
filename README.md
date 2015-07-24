# PhoneNumberFormatter

**Provides visual formatting of phone number fields, while typing. Format is defined by Regex patterns and can be localized.**


## Including in Your App

There are two files to add to your app: PhoneNumberFormatter.swift and StringExtension.swift. 

(*If you already have Dollar/Cent or lots of string customization, you may want to alter StringExtension/LocalizedPhone to utilize your own code. Otherwise, yay new String features!*)

Then, wire up your phone number field's **Editing Changed** action and call the formatter in there:

```swift
var phoneFormatter = PhoneNumberFormatter()
@IBAction func formatField(sender: UITextField) {
    sender.text = phoneFormatter.format(sender.text, hash: sender.hash)
}
```

The formatter will change **2065551234** to **(206) 555-1234** (sorry, the formatter does not currently understand 7-digit phone numbers). It will also recognize backspace commands and remove number values instead of formatting characters, to make for a better user experience.

## More Things

- There is an additional phoneFormatter.isValid() function available to test if a complete phone number was entered (to call before submitting the form).
- You can add new locales and formats easily with Regex.

