# KARATE
## Links
### Course
https://www.udemy.com/course/karate-dsl-api-automation-and-performance-from-zero-to-hero

https://github.com/bondar-artem/karate-dsl-class

https://conduit.bondaracademy.com

https://conduit-api.bondaracademy.com

### Karate page
https://github.com/karatelabs/karate

# Main
- Multi-thread parallel execution
- Detailed reporting and logs

# Notes
The xyz.feature file is only executed by the mnoTest.java runner in the same folder.

## Scenarios
```gherkin

    Scenario: Get all tags
        Given url 'https://conduit-api.bondaracademy.com/api/tags'
        When method Get
        Then status 200

    Scenario: Get 10 articles from the page
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