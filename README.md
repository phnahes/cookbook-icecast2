Description
===========
Install and Configures Icecast2

Usage
=====
Include the icecast2 recipe on the server.

Databags are able to be used for storing clients informations.

Example Databags
================

Client - Teste1
-------------------------
{
        "name" : "teste1",
        "port" : "8000",
        "logLevel" : "3",
        "numClients" : "100",
        "sourcePass" : "sourcepass123",
        "adminPass" : "adminpass123",
        "maxListener" : "100",
        "maxListenerDuration" : "3600",
        "bitrate" : "56"
}

License and Author
==================

Author:: Paulo Nahes (<phnahes@gmail.com>)

