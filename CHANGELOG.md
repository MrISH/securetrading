# Securetrading change log

## 0.4.1 / Unreleased

* [Added] 

* [Deprecated]

* [Removed]

* [Fixed]
  * Fix ruby 1.9.3 compatibility

## 0.4.0 / 2015-12-17

* [Added] 
  * Allow to pass configuration options directly to requests.

* [Deprecated]

* [Removed]

* [Fixed]

## 0.3.2 / 2015-09-07

* [Fixed]
  * make attributes_hash public

## 0.3.1 / 2015-08-28

* [Fixed]
  * Amount xml generation

## 0.3.0 / 2015-08-25

* [Added] 
  * Securetrading::SiteSecurity.hash(fields) to return SHA256 encoded sitesecurity value from hash of fields to encode.
  * auth_method configuration value
  * site_security_password configuration value
  * Securetrading::Response to objectify response from httparty

* [Deprecated]
  * Renamed Filter class to TransactionQuery class as much more relevant.

## 0.2.0 / 2015-08-14

* [Added] Filter - query API for transactions details.

## 0.1.0 / 2015-08-13

* [Added] Possibility to send REFUND request to API.
