# KARATE
## Links
### Course
https://www.udemy.com/course/karate-dsl-api-automation-and-performance-from-zero-to-hero

https://github.com/bondar-artem/karate-dsl-class

https://conduit.bondaracademy.com

https://conduit-api.bondaracademy.com

### Karate page
https://github.com/karatelabs/karate

## Main points
- Multi-threaded parallel execution
- Detailed reports and logs

## Notes
### The xyz.feature file is only executed by the mnoTest.java runner in the same folder.
### Printing to the Console
    * print 'Username [DEBUG]:', username
    * print 'Email  [DEBUG]:', email
### IMPORTANT
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

## Calling others features

### 📌 Organizing features in Karate
* All **features that are part of the test suite (e.g., `mvn test`)** must be **in the same directory as the runner (`XTest.java`)**.
* Any feature **outside this directory will not be executed automatically**.

👉 **Main point:**
**If a feature is outside the runner’s (`XTest.java`) directory, it will NOT run during the suite execution.**

---

### ⚙️ Call vs CallOnce

* `call` → executes **every time it is invoked**
* `callonce` → executes **only once** (usually in the `Background`)

### 📦 Passing parameters

* You can pass data to another feature like this:

```gherkin
* call read('feature.feature') { param: 'value' }
```

### 🧠 Final summary

* ✔ Features inside the `XTest.java` folder → run in the suite
* ❌ Features outside this folder → do not run automatically
* 🔁 Use external features for reuse (helpers)
* ⚡ Use `callonce` to optimize execution

## Example code
```gherkin
Background: Create a new user - Ensure it runs once for both different username/email combinations
    Given url 'https://conduit-api.bondaracademy.com/api/'
    * def randomNum = Math.floor(Math.random() * 1000)
    * def username = 'user_' + randomNum
    * def email = 'test_' + randomNum + '@test.com'
    * def featureClasspath = 'classpath:com/paradigma0621/pockarate/example/helpers/createUser.feature'
    # Variables defined above to illustrate the call with arguments below
    * def userData = call read(featureClasspath) { username: #(username), email: #(email) }
    * def token = userData.tokenAuthorization
    * def articleTitle = "Some words19"

# /helpers/createUser.feature
Feature: Create user just once
    Scenario:
        Given url 'https://conduit-api.bondaracademy.com/api/'
        Given path 'users'
        And request {"user": {"username": "#(username)" , "email": "#(email)", "password": "karate123"}}
        * print 'Username [DEBUG]:', username
        * print 'Email  [DEBUG]:', email
        When method Post
        Then status 201
        * def tokenAuthorization = response.user.token
```
```gherkin
* def createUserParams =
"""
{
  username: #(username),
  email: #(email)
}
"""
* def userData = call read(featureClasspath) createUserParams
```
## Enviroment variables
```js
// karate-config.js
  var config = { // Properties set in `config` (karate-config.js) become globally accessible variables in Karate
	  apiUrl: 'https://conduit-api.bondaracademy.com/api/'
  }

  if (env == 'dev') { // Properties set in `config` (karate-config.js) become globally accessible variables in Karate
    config.passwordFromConfig = 'KarateDEV123'
  }
  if (env == 'qa') { // Properties set in `config` (karate-config.js) become globally accessible variables in Karate
    config.passwordFromConfig = 'KarateQA456'
  }  
```
### Command line
```
mvn test -Dkarate.env="qa"
```

### Variables use examples
```gherkin
# Given url 'https://conduit-api.bondaracademy.com/api/'
# CHANGES TO:
Given url apiUrl
...
# 'passwordFromConfig' is defined in karate-config.js and is globally available via config
And request {"user": {..."password": "#(passwordFromConfig)"}} 
``` 

### Additional declarations (pending testing)
```js
// karate-config.js
var accessToken = karate.callSingle('classpath:helpers/CreateToken.feature', config).authToken
karate.configure('headers', {Authorization: 'Token ' + accessToken})
```