# Code Challenge Submission

This repo is my submission for the items listed below.

The code for item 1 is in ECCreditCard.h.

## Code Challenge:

Please use objective-c to implement all of the solutions below.

### 1) Sample: Parsing and Validating Credit Cards

Write a new class called ECCreditCard that represents a user’s (possibly invalid) credit card. For the purposes of this example, only the following brands of credit card should be considered valid: American Express, Discover, MasterCard, Visa. It should be initialized with a string representing the credit card number.

The class should have a public readonly property to allow you to query the card issuer (from the above list, or “Unknown”). It should also have a public readonly property to query whether or not the card is valid. Validity should be determined based on whether the card is from one of the above issuers, has the correct length, and has a correct check digit (using the Luhn algorithm).

Please write unit tests to verify your solution.

Information about how credit card numbers are implemented can be found here: https://en.wikipedia.org/wiki/Bank_card_number
Some sample credit card numbers can be found here: https://www.paypalobjects.com/en_US/vhelp/paypalmanager_help/credit_card_numbers.htm


### 2) UI Exercise: Pets

A common paradigm in our code is a service based UI. We get data from a service and display it in a view, and allow the user to interact or edit the data. 

For this exercise, create a simple Master/Detail application that displays a list of pets. The Master controller will display the list of all pets, and the Detail controller will allow you to see and edit details of a specific pet. 

Requirements

  * The application should support displaying and editing the properties of a pet.
  * Pets need at least 2 attributes
  * Implement a class or classes that is responsible for returning or manipulating pets. This class/classes should simulate a long running process ( fake data is fine )
  * Master controller shows all the pets
  * Detail controller allows one to edit a pet


