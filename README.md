#Moonshine appCanary
==============================

A [Moonshine](https://github.com/railsmachine/moonshine) plugin for installing
and managing the [appCanary](https://appcanary.com/) agent.

### Requirements

* An [appCanary](https://appcanary.com/) account
* The API key for your account.

### Quickstart Instructions

* `script/plugin install git://github.com/railsmachine/moonshine_appcanary.git`
* Configure API key in `config/moonshine.yml`

```
  :appcanary:
    :api_key: YOUR-APPCANARY-API-KEY
```

* Include the recipe in your Moonshine manifest

```
  recipe :appcanary
```
---
Unless otherwise specified, all content copyright &copy; 2015, [Rails Machine, LLC](https://railsmachine.com)

