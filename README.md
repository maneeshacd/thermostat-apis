# THERMOSTAT APIs

## Table Data

### Thermostat

| Key | DataType | Validation |
| ------ | ------ | ------ |
| id | integer | uniq |
| household_token | string | not null, uniq |
| address | text | not null
| created_at | datetime | not null |
| updated_at | datetime | not null |

### Reading

| Key | DataType | Validation |
| ------ | ------ | ------ |
| id | integer | uniq |
| thermostat_id | bigint | uniq, not null |
| number | integer | uniq, not null |
| temperature | float | not null |
| humidity | float | not null |
| battery_charge | float | not null
| created_at | datetime | not null |
| updated_at | datetime | not null |

## APIs

| Url | Description | Arguments | Return |
| ------ | ------ | ------ | ------ |
| POST /readings | Stores temperature, humidity and battery charge from a particular thermostat. | household_token, temperature, humidity, battery_charge | Reading data |
| GET /:reading_id/thermostat_details | Returns the thermostat data using the reading_id obtained from POST Reading. | reading_id | Thermostat data |
| GET /thermostat_statistics | Gives the average, minimum and maximum by temperature, humidity and battery_charge in a particular thermostat across all the period of time. | household_token | Thermostat statistics |

## Get started

### Seed thermostat data

```sh
rails db:seed
```

### Start rails server

```sh
rails s
```

### start sidekiq

```sh
bundle exec sidekiq
```

### start sidekiq

```sh
bundle exec sidekiq
```

### Test with rspec

```sh
bundle exec rspec spec
```

### Samples

```sh
  header
    {
      "Content-Type": "application/json",
      "Api-Key": 'apikey',
      "Api-Secret": 'apisecret'
    }
```

#### POST /readings
  ##### Request
  ```sh
    body
      {
        "household_token": "FG4Pz7DMPQI5i5JT874O",
        "temperature": 10.00,
        "humidity": 10.00,
        "battery_charge": 30.00

      }
  ```
  ##### Response
  ```sh
    {
        "status": "success",
        "code": 201,
        "data": {
            "reading": {
                "id": 16,
                "thermostat_id": 2,
                "number": 15,
                "temperature": 10,
                "humidity": 10,
                "battery_charge": 30
            }
        },
        "message": "Success"
    }
  ```
  
#### GET /14/thermostat_details
  ##### Request
  ```sh
    body {}
  ```
  ##### Response
  ```sh
    {
      "status": "success",
      "code": 200,
      "data": {
          "thermostat": {
              "id": 2,
              "household_token": "FG4Pz7DMPQI5i5JT874O",
              "address": "Hohenzollernring 56, 48145 Münster, Germany"
          }
      },
      "message": "Success"
    }
  ```
  
#### POST /thermostat_statistics
  ##### Request
  ```sh
    body
      {
        "household_token": "FG4Pz7DMPQI5i5JT874O"
      }
  ```
  ##### Response
  ```sh
    {
        "status": "success",
        "code": 200,
        "data": {
            "statistics": {
                "temperature": {
                    "min": 10.08,
                    "avg": 10.08,
                    "max": 10.08
                },
                "humidity": {
                    "min": 10,
                    "avg": 11.33,
                    "max": 20
                },
                "battery_charge": {
                    "min": 30,
                    "avg": 30,
                    "max": 30
                }
            },
            "thermostat": {
                "id": 2,
                "household_token": "FG4Pz7DMPQI5i5JT874O",
                "address": "Hohenzollernring 56, 48145 Münster, Germany"
            }
        },
        "message": "Success"
    }
  ```
