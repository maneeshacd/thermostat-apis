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
| GET /readings/:reading_id/thermostats/:id | Returns the thermostat data using the token as reading_id obtained from POST Reading and household_token as id. | reading_id - token, id - household_token | Thermostat data |
| GET /statistics/:id | Gives the average, minimum and maximum by temperature, humidity and battery_charge in a particular thermostat across all the period of time. | id - household_token | Thermostat statistics |

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
                "thermostat_id": 1,
                "number": 5,
                "temperature": 9,
                "humidity": 10,
                "battery_charge": 30,
                "token": "dc34807b78a144e5c551"
            }
        },
        "message": "Success"
    }
  ```
  
#### GET /readings/4ef1b6ecf0ee1ecafcad/thermostats/pypNs7Zxf1onDDDzVmQf
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
                "id": 1,
                "household_token": "pypNs7Zxf1onDDDzVmQf",
                "address": "Europa-Allee 50; 60327 Frankfurt am Main, Germany"
            }
        },
        "message": "Success"
    }
  ```
  
#### GET /statistics/pypNs7Zxf1onDDDzVmQf
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
            "statistics": {
                "temperature": {
                    "min": 9,
                    "avg": 9.67,
                    "max": 10
                },
                "humidity": {
                    "min": 10,
                    "avg": 10,
                    "max": 10
                },
                "battery_charge": {
                    "min": 30,
                    "avg": 30,
                    "max": 30
                }
            },
            "thermostat": {
                "id": 1,
                "household_token": "pypNs7Zxf1onDDDzVmQf",
                "address": "Europa-Allee 50; 60327 Frankfurt am Main, Germany"
            }
        },
        "message": "Success"
    }
  ```
