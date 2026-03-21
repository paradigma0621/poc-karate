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



{
    "user": {
        "id": 49394,
        "email": "abc1234@test.com",
        "username": "karate@test.com",
        "bio": null,
        "image": "https://conduit-api.bondaracademy.com/images/smiley-cyrus.jpeg",
        "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7ImlkIjo0OTM5NH0sImlhdCI6MTc3NDA1NjY3NiwiZXhwIjoxNzc5MjQwNjc2fQ.O6j4axDgAEKPt8Fr5h5CuI7efYovjM-BDfRPZ2UVDkE"
    }
}

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