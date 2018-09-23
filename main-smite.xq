declare namespace smite = "http://api.smitegame.com/";
import module namespace lib = "http://api.smitegame.com/lib" at "lib-smite.xq";

(: lib:createsession() :)
lib:ping()
(: lib:get("testsession", "SESSIONID",()) :)
(: lib:get("getgodleaderboard", "SESSIONID", ("10", "451")) :)
(: lib:get("getpatchinfo", "SESSIONID", ()) :)