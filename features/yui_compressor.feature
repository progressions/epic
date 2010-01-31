Feature: Compress JavaScript and Stylesheet files

  Background:
    Given I configure Epic::Base to compile with YUI
    
  Scenario: Compress a valid JavaScript file
    Given I compress the file "javascripts/valid_uncompressed.js"
    And I open the file "javascripts/valid_uncompressed.js.min"
    Then I should see "var hello\=function\(a\)"
    And no exceptions should have been raised
    And I remove the file "javascripts/valid_uncompressed.js.min"
    
  Scenario: Compress an invalid JavaScript file
    Given I compress the file "javascripts/invalid_uncompressed.js"
    Then an exception should have been raised with the message "JavaScript errors"
    
  Scenario: Don't re-compress if compressed file exists
    Given I compress the file "javascripts/pre_compressed.js"
    And I open the file "javascripts/pre_compressed.js.min"
    Then I should see "function alreadyCompressed\(b\)"
    
  Scenario: Raise an error if the original file doesn't exist
    Given I compress the file "javascripts/nonexistent.js"
    Then an exception should have been raised with the message "No such file or directory"
    

  Scenario: Compress a valid JavaScript file to a destination
    Given I compress the file "javascripts/valid_uncompressed.js" to "features/data/javascripts/valid_uncompressed.js.compressed"
    And I open the file "javascripts/valid_uncompressed.js.compressed"
    Then I should see "var hello\=function\(a\)"
    And no exceptions should have been raised
    And I remove the file "javascripts/valid_uncompressed.js.compressed"    
    
  
  Scenario: Compress a valid JavaScript file to a destination with a full path
    Given I compress the file "javascripts/valid_uncompressed.js" to "/valid_uncompressed.js.compressed"
    And I open the file "/valid_uncompressed.js.compressed"
    Then I should see "var hello\=function\(a\)"
    And no exceptions should have been raised
    And I remove the file "/valid_uncompressed.js.compressed"    
    
    
    