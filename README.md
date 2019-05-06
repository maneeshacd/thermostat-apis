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
| GET /readings/:id | Returns the thermostat and reading data using the token as reading_id obtained from POST Reading and household_token as id. | id - token | Reading and Thermostat data |
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
        "household_token": "pypNs7Zxf1onDDDzVmQf",
        "temperature": 9,
        "humidity": 10,
        "battery_charge": 30

      }
  ```
  ##### Response
  ```sh
    {
        "data": {
            "id": null,
            "type": "reading",
            "attributes": {
                "number": 3,
                "token": "3808d1a47e90e18de267",
                "temperature": 9,
                "humidity": 1090,
                "battery_charge": 30,
                "thermostat_id": 1
            },
            "relationships": {
                "thermostat": {
                    "data": {
                        "id": "1",
                        "type": "thermostat"
                    }
                }
            }
        }
    }
  ```

#### GET /readings/1aceb8075d4e84f9de37
  ##### Request
  ```sh
    body {}
  ```
  ##### Response
  ```sh
    {
        "data": {
            "id": "6",
            "type": "reading",
            "attributes": {
                "number": 1,
                "token": "1aceb8075d4e84f9de37",
                "temperature": 9,
                "humidity": 10,
                "battery_charge": 30,
                "thermostat_id": 1
            },
            "relationships": {
                "thermostat": {
                    "data": {
                        "id": "1",
                        "type": "thermostat"
                    }
                }
            }
        },
        "included": [
            {
                "id": "1",
                "type": "thermostat",
                "attributes": {
                    "household_token": "pypNs7Zxf1onDDDzVmQf",
                    "address": "Europa-Allee 50; 60327 Frankfurt am Main, Germany"
                }
            }
        ]
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
        "data": {
            "id": null,
            "type": "statistics",
            "attributes": {
                "values": {
                    "temperature": {
                        "min": 9,
                        "avg": 9,
                        "max": 9
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
            }
        }
    }
  ```

#### Error Response format
  ##### Response
  ```sh
    {
        "data": {
            "id": null,
            "type": "error",
            "attributes": {
                "code": <Error code>,
                "message": <Error Message>
            }
        }
    }
  ```
  ##### Example
  ```sh
    {
        "data": {
            "id": null,
            "type": "error",
            "attributes": {
                "code": 404,
                "message": "Object Not Found"
            }
        }
    }
  ```
