# KARATE
## Links
### Course
https://www.udemy.com/course/karate-dsl-api-automation-and-performance-from-zero-to-hero

https://github.com/bondar-artem/karate-dsl-class

https://conduit.bondaracademy.com

https://conduit-api.bondaracademy.com

### Karate page
https://github.com/karatelabs/karate

# Main points
- Multi-threaded parallel execution
- Detailed reports and logs

# Notes
The xyz.feature file is only executed by the mnoTest.java runner in the same folder.

## IMPORTANT
The Background is executed **before every** Scenario.

## GET Scenarios
### Simplest example
```gherkin
Scenario: Get all tags
    Given url 'https://conduit-api.bondaracademy.com/api/tags'
    When method Get
    Then status 200
```

### Using parameters
```gherkin
Scenario: Get 10 articles from the page using parameters
    # Use case 1
    #    Given url 'https://conduit-api.bondaracademy.com/api/articles?limit=10&offset=0'

    # Use case 2
    # Given param limit = 10
    # Given param offset = 0
    #    Given url 'https://conduit-api.bondaracademy.com/api/articles'

    # Use case 3
    Given params { limit: 10, offset: 0 }
    Given url 'https://conduit-api.bondaracademy.com/api/articles'
    When method Get
    Then status 200
```

### Using `url` and `path`
```gherkin
# Given url 'https://conduit-api.bondaracademy.com/api/tags'
# becomes...

Background: Define URL
    Given url 'https://conduit-api.bondaracademy.com/api/'
...     
Scenario: Get all tags
    Given path 'tags'
```
### Assertions
#### Array contains a single element
```gherkin
Scenario: Get all tags
    Given path 'tags'
    When method Get
    Then status 200
    And match response.tags contains 'Start for Free'
```

#### Array contains multiple elements
```gherkin
Scenario: Get all tags
    Given path 'tags'
    When method Get
    Then status 200
    And match response.tags contains ['Start for Free', 'Slack']
```

#### Does not contain
```gherkin
Scenario: Get all tags
    Given path 'tags'
    When method Get
    Then status 200
    And match response.tags !contains 'abc123'
```

#### The response is an array
```gherkin
Scenario: Get all tags
    Given path 'tags'
    When method Get
    Then status 200
    And match response.tags == "#array"
```

#### Each response element contains only strings
```gherkin
Scenario: Get all tags
    Given path 'tags'
    When method Get
    Then status 200
    And match each response.tags == "#string"
```

#### Equals ('==') assertions
```gherkin
Scenario: Get 10 articles from the page using parameters
    Given params { limit: 10, offset: 0 }
    Given path 'articles'
    When method Get
    Then status 200
    # The array returned has 10 elements
    And match response.articles == '#[10]'
    # The element 'articlesCount' has value = 10
    And match response.articlesCount == 10
```

## POST Scenarios
### Simplest example
Ensure it runs once for both different username/email combinations.
```gherkin
Feature: Articles

    Background: Define URL
        Given url 'https://conduit-api.bondaracademy.com/api/'

    Scenario: Create a new user - Ensure it runs once for both different username/email combinations
        Given path 'users'
        And request {"user": {"username": "karate123@test.com", "email": "abc123@test.com","password": "karate123"}}
        When method Post
        Then status 201
        And match response.user.token == "#string"
```

### Example using Background complete cenario
```gherkin
Feature: Articles

    Background: Create a new user - Ensure it runs once for both different username/email combinations
        Given url 'https://conduit-api.bondaracademy.com/api/'
        Given path 'users'
        * def randomNum = Math.floor(Math.random() * 1000)
        * def username = 'user_' + randomNum
        * def email = 'test_' + randomNum + '@test.com'

        And request {"user": {"username": "#(username)" , "email": "#(email)", "password": "karate123"}}
        When method Post
        Then status 201
        * def token = response.user.token

    Scenario: Create a new article
        Given header Authorization = 'Token ' + token
        Given path 'articles'
        And request {"article": {"title": "Bla bla111", "tagList": ["someTag"],"description": "test test", "body": "body article message"}}
        When method Post
        Then status 201
        And match response.article.title == 'Bla bla111'
```

## Using Tags

Note: a line can contain more than one flag.

### Run / Skip Features by Tag

```gherkin
@mytagfeature
Feature: Tests for the home page
```

Command line:

```
mvn test -Dkarate.options="--tags @mytagfeature"     # Runs only features tagged with @mytagfeature
mvn test -Dkarate.options="--tags ~@mytagfeature"    # Skips features tagged with @mytagfeature
```

### Run / Skip Scenarios by Tag

```gherkin
@mytag
Scenario: Get all tags
```

Command line:

```
mvn test -Dkarate.options="--tags @mytag"      # Runs only scenarios tagged with @mytag
mvn test -Dkarate.options="--tags ~@mytag"     # Skips scenarios tagged with @mytag
```

### Ignoring Tests

#### `@ignore`

Use this tag to exclude a Feature or Scenario from execution.

```gherkin
@ignore
Feature: Articles
```

or

```gherkin
@ignore
Scenario: Get all tags
```