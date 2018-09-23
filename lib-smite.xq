module namespace lib =  "http://api.smitegame.com/lib";

declare variable $lib:devId := doc("settings.xml")/Settings/Username/text();
declare variable $lib:authKey := doc("settings.xml")/Settings/Password/text();
declare variable $lib:api := "http://api.smitegame.com/smiteapi.svc";
declare variable $lib:responseType := "XML";

declare function lib:timestamp() as xs:string {
  let $dateTime := adjust-dateTime-to-timezone(current-dateTime(), xs:dayTimeDuration("PT0H"))
  return $dateTime => format-dateTime("[Y,4][M,2][D,2][H,2][m,2][s,2]")
};

declare function lib:signature($command as xs:string, $timestamp as xs:string) as xs:string {
  let $concat := $lib:devId || $command || $lib:authKey || $timestamp
  let $signature := hash:md5($concat) => xs:hexBinary() => xs:string() => lower-case()
  return $signature
};

declare function lib:ping() {
  let $command := "ping"
  let $href := ($lib:api, $command || $lib:responseType) => string-join("/") => trace()
  let $request := <http-request method='get' href='{$href}' timeout="10" />
  return
    http:send-request($request)
};

declare function lib:createsession() {
  let $command := "createsession"
  let $timestamp := lib:timestamp()
  let $signature := lib:signature($command, $timestamp)
  let $href := ($lib:api, $command || $lib:responseType, $lib:devId, $signature, $timestamp) => string-join("/") => trace()
  let $request := <http-request method='get' href='{$href}' timeout="10" />
  return
    http:send-request($request)
};

declare function lib:get($command as xs:string, $session as xs:string, $params as xs:string*) {
  let $timestamp := lib:timestamp()
  let $signature := lib:signature($command, $timestamp)
  let $href := ($lib:api, $command || $lib:responseType, $lib:devId, $signature, $session, $timestamp, $params) => string-join("/") => trace()
  let $request := <http-request method='get' href='{$href}' timeout="10" />
  return
    http:send-request($request)
};