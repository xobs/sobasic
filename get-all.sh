#!/bin/sh
mkdir -p pages
export IFS=','
components="Bead/Filter/EMI Optimization,Capacitors,Communication Interface Chip/UART/485/232,Crystal Oscillator/Oscillator/Resonator,Diodes,Inductors/Coils/Transformers,Key/Switch,Logic ICs,Memory,Nixie Tube Driver/LED Driver,Operational Amplifier/Comparator,Optocoupler/LED/Digital Tube/Photoelectric Device,Optocouplers & LEDs & Infrared,Power Supply Chip,Resistors,RTC/Clock Chip,Sensors,Single Chip Microcomputer/Microcontroller,Triode/MOS Tube/Transistor,TVS/Fuse/Board Level Protection"
for component in $components
do
    # for page in $(seq 35)
    # do
    # curl 'https://jlcpcb.com/api/overseas-pcb-order/v1/shoppingCart/smtGood/selectSmtComponentList' -X POST -H 'Accept: application/json, text/plain, */*' -H 'Content-Type: application/json' --data-raw '{"currentPage":'$page',"pageSize":25,"keyword":"","firstSortName":"","firstSortNameNew":"","firstSortId":"","secondSortName":"","componentAttributes":[],"componentLibraryType":"base","componentLibraryTypeCheck":false,"preferredComponentFlag":true,"preferredComponentFlagCheck":false,"componentSpecification":null,"componentAttributes":[],"searchSource":"search","componentLibraryType":"base","stockFlag":null,"stockSort":null}' > "pages/$run-run-page-$page.json"
    # done
    component_noslash=$(echo $component | tr / .)
    curl 'https://jlcpcb.com/api/overseas-pcb-order/v1/shoppingCart/smtGood/selectSmtComponentList' -X POST -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/119.0' -H 'Accept: application/json, text/plain, */*' -H 'Accept-Language: en-GB,en;q=0.5' -H 'Accept-Encoding: gzip, deflate, br' -H 'Content-Type: application/json' -H 'secretkey: 39623565633937622d333666302d343061382d613837352d333966396266333138303062' -H 'X-XSRF-TOKEN: 9137b50e-7297-4aff-93b9-0a82b2537e8b' -H 'Origin: https://jlcpcb.com' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Referer: https://jlcpcb.com/parts/basic_parts' -H 'Cookie: traceUrl=%7B%22advertisingUrl%22%3A%22https%3A%2F%2Fjlcpcb.com%2F%22%2C%22websiteUrl%22%3A%22https%3A%2F%2Fcart.jlcpcb.com%2Fquote%2F%3ForderType%3D1%26stencilLayer%3D4%26stencilWidth%3D100%26stencilLength%3D100%26stencilCounts%3D5%22%7D; nowMoneyName=%24; iconCountryExchangeRateFlag=USD; nowExchangeRate=1; jlc_customer_code=2661708A; jlc_session_code=WAltRd7HdyLUQcvYRIzynA%3D%3D; client_login_info=%7B%22login_time%22%3A%222023-11-30+09%3A35%3A05%22%2C%22customer_code%22%3A%222661708A%22%7D; __stripe_mid=9f5fff3e-2cdf-4c1c-ab74-139e3f3c7162d49717; isPay=1; JSESSIONID=3502FB6E4C66EA87BBDCB2B5CAFDF143; JLCPCB_SESSION_ID=6bbfcd3b-ae4f-4831-ad13-f5d056b53d69; nowMoneyName=$; nowExchangeRate=1; ONEKEYID=93cfcbd7-1a56-42c3-8712-8034f5b8fd36; XSRF-TOKEN=9137b50e-7297-4aff-93b9-0a82b2537e8b' -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: same-origin' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' -H 'TE: trailers' --data-raw '{"keyword":"","firstSortName":"'$component'","firstSortNameNew":"'$component'","firstSortId":"","currentPage":1,"pageSize":500,"searchSource":"search","componentAttributes":[],"componentLibraryType":"base","preferredComponentFlag":true,"stockFlag":null,"stockSort":null,"componentBrand":null,"componentSpecification":null}' > pages/$component_noslash.json
done

# curl 'https://jlcpcb.com/api/overseas-pcb-order/v1/shoppingCart/smtGood/selectSmtComponentList' -X POST -H 'Accept: application/json, text/plain, */*' -H 'Content-Type: application/json' --data-raw '{"currentPage":'$page',"pageSize":25,"keyword":"","firstSortName":"Inductors/Coils/Transformers","firstSortNameNew":"Inductors/Coils/Transformers","firstSortId":"80310","secondSortName":"","componentAttributes":[],"componentLibraryType":"base","componentLibraryTypeCheck":false,"preferredComponentFlag":true,"preferredComponentFlagCheck":false,"componentSpecification":null,"componentAttributes":[],"searchSource":"search","componentLibraryType":"base","stockFlag":null,"stockSort":null}' | jq .

# curl 'https://jlcpcb.com/api/overseas-pcb-order/v1/shoppingCart/smtGood/selectSmtComponentList' -X POST -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/119.0' -H 'Accept: application/json, text/plain, */*' -H 'Accept-Language: en-GB,en;q=0.5' -H 'Accept-Encoding: gzip, deflate, br' -H 'Content-Type: application/json' -H 'secretkey: 39623565633937622d333666302d343061382d613837352d333966396266333138303062' -H 'X-XSRF-TOKEN: 9137b50e-7297-4aff-93b9-0a82b2537e8b' -H 'Origin: https://jlcpcb.com' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Referer: https://jlcpcb.com/parts/basic_parts' -H 'Cookie: traceUrl=%7B%22advertisingUrl%22%3A%22https%3A%2F%2Fjlcpcb.com%2F%22%2C%22websiteUrl%22%3A%22https%3A%2F%2Fcart.jlcpcb.com%2Fquote%2F%3ForderType%3D1%26stencilLayer%3D4%26stencilWidth%3D100%26stencilLength%3D100%26stencilCounts%3D5%22%7D; nowMoneyName=%24; iconCountryExchangeRateFlag=USD; nowExchangeRate=1; jlc_customer_code=2661708A; jlc_session_code=WAltRd7HdyLUQcvYRIzynA%3D%3D; client_login_info=%7B%22login_time%22%3A%222023-11-30+09%3A35%3A05%22%2C%22customer_code%22%3A%222661708A%22%7D; __stripe_mid=9f5fff3e-2cdf-4c1c-ab74-139e3f3c7162d49717; isPay=1; JSESSIONID=3502FB6E4C66EA87BBDCB2B5CAFDF143; JLCPCB_SESSION_ID=6bbfcd3b-ae4f-4831-ad13-f5d056b53d69; nowMoneyName=$; nowExchangeRate=1; ONEKEYID=93cfcbd7-1a56-42c3-8712-8034f5b8fd36; XSRF-TOKEN=9137b50e-7297-4aff-93b9-0a82b2537e8b' -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: same-origin' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' -H 'TE: trailers' --data-raw '{"keyword":"","firstSortName":"Resistors","firstSortNameNew":"Resistors","firstSortId":"","currentPage":1,"pageSize":25,"searchSource":"search","componentAttributes":[],"componentLibraryType":"base","preferredComponentFlag":true,"stockFlag":null,"stockSort":null,"componentBrand":null,"componentSpecification":null}'

#     Bead/Filter/EMI Optimization
#     Capacitors
#     Communication Interface Chip/UART/485/232
#     Crystal Oscillator/Oscillator/Resonator
#     Diodes
#     Inductors/Coils/Transformers
#     Key/Switch
#     Logic ICs
#     Memory
#     Nixie Tube Driver/LED Driver
#     Operational Amplifier/Comparator
#     Optocoupler/LED/Digital Tube/Photoelectric Device
#     Optocouplers & LEDs & Infrared
#     Power Supply Chip
#     Resistors
#     RTC/Clock Chip
#     Sensors
#     Single Chip Microcomputer/Microcontroller
#     Triode/MOS Tube/Transistor
#     TVS/Fuse/Board Level Protection
