To build, select your team, bundle name is unique (I hope so) otherwise rename and you are good to go. :) 

Project Structure

DemoApp - Has the main code

    MVVM Design pattern is used in this mini project,

Networking/ Helper

    Networking uses
        - Apple's Singleton URLSessions
        - Abstracted Protocol 
        - Networking class using DI

Models 

    use Decodable Protocols
    
Extensions

    Currently has only Date and double extension. 

Folders

    The folder names are self explanatory of the content.
    current project has only a single view controller, and
    one custom table cell, which could be a part of table itself but better to create xib for reusability. 

demoAppTests - TestCode

    MockData *2 - Has dummy data in Json provided by the API
    Testcases now are in simple files, but with project size, must be abstracted.
