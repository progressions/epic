Feature: Test the validator

  Background:
    Given I configure Epic::Base
    
  Scenario: Validate a valid HTML file
    Given the file "html/valid.html" should be valid
  
  Scenario: Validate an invalid HTML file
    Given the file "html/invalid.html" should not be valid
    
  Scenario: Validate a valid JavaScript file
    Given the file "javascripts/valid.js" should be valid
    
  Scenario: Validate an invalid JavaScript file
    Given the file "javascripts/invalid.js" should not be valid
    