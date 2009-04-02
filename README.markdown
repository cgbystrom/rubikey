Rubikey
========

A Yubikey validation server written in Ruby using Sinatra and JSON

Rubikey will validate the OTPs generated Yubikeys. It's intended to be used by other back-end services for authenticating users' keys. A simple REST client is everything that's needed :)

It currently isn't anything ready for production use. It's mainly a toy project I created to see how easy it would be to port Yubikey's own validation server to Ruby.
The official versions (Java and PHP) is a mess of interdependencies and outdated docs. Porting to Ruby was very straight forward and Sinatra provides a lightweight yet powerful enough abstraction for creating simple web services.
Perfect match I'd say!

What is Yubikey?
----------------
From [Wikipedia][1]:

YubiKey is a device that acts as a USB keyboard and provides secure authentification by a one-time password algorithm. The YubiKey is what is known as a security token The device is created by a company called Yubico. The device creates a 128 bit string of characters that acts as a password. This device draws power from the USB port and does not contain batteries or use other power supplies. Since it acts as a USB keyboard, there is no software to accompany it.


How to use
----------
Install the dependencies

    sudo rake gems:install

*Add your key to the DB (to be fixed, do it manually)*

Running Rubikey

    ruby application.rb 

Try authenticating your OTP

     curl http://localhost:4567verify?otp=<INSERT_OTP_HERE>


Todo
----
* **Key-value storage**
Currently using DataMapper and Sqlite for storing the keys and users. Perhaps try using a key-value database for better performance and hype factor. CouchDB, Tokyo Cabinet, Redis anyone?
* **Benchmark**
I haven't done any performance testing, but I expect performance to be perfectly acceptable for production use. Perhaps even more so after a switch to a key-value storage.
* **Admin interface**
Create an admin interface for easier administration of keys and users. This isn't the main goal, I wanted Rubikey to as simple as possible. Not cluttered with loads of UI code.
* Try out some new ways of deployment (Thin?)


Comparsion
----------

TODO: A comparison with the Java and PHP version of Yubikey's official validation servers with Rubikey. Lines of code should differ quite a bit :)
  [1]: http://en.wikipedia.org/wiki/Yubikey
