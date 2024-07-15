#!/bin/sh
mkdir -p pages
export IFS=','

# components=$(curl -q https://jlcpcb.com/parts/basic_parts | sed 's/</\n/g' | grep -A 99999999 'All Components' | sed '/Reset All/q' | grep whitespace-nowrap  | cut -d'>' -f2 | sed 's/\&amp;/\&/g' | tr '\n' ',')

components="Amplifiers/Comparators,Audio Products/Motors,Capacitors,Circuit Protection,Clock/Timing,Connectors,Crystals, Oscillators, Resonators,Data Acquisition,Development Boards & Tools,Diodes,Displays,Electronic Tools/Instruments/Consumables,Embedded Processors & Controllers,Filters,Global Sourcing Parts,Hardware/Fasteners/Sealing,Inductors, Coils, Chokes,Interface,IoT/Communication Modules,Isolators,LED Drivers,Logic,Magnetic Sensors,Memory,Motor Driver ICs,Old Batch,Optocouplers & LEDs & Infrared,Optocouplers/Photocouplers,Optoelectronics,Power Management ICs,Power Modules,Relays,Resistors,RF And Wireless,Sensors,Silicon Carbide (SiC) Devices,Switches,Transistors/Thyristors,Triode/MOS Tube/Transistor,TVS/Fuse/Board Level Protection"

for component in $components
do
    component_noslash=$(echo $component | tr / .)
    for tries in 1 2 3 4 5
    do
        curl 'https://jlcpcb.com/api/overseas-pcb-order/v1/shoppingCart/smtGood/selectSmtComponentList' -X POST -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/119.0' -H 'Accept: application/json, text/plain, */*' -H 'Accept-Language: en-GB,en;q=0.5' -H 'Accept-Encoding: gzip, deflate, br' -H 'Content-Type: application/json' -H 'secretkey: 39623565633937622d333666302d343061382d613837352d333966396266333138303062' -H 'X-XSRF-TOKEN: 9137b50e-7297-4aff-93b9-0a82b2537e8b' -H 'Origin: https://jlcpcb.com' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Referer: https://jlcpcb.com/parts/basic_parts' -H 'Cookie: traceUrl=%7B%22advertisingUrl%22%3A%22https%3A%2F%2Fjlcpcb.com%2F%22%2C%22websiteUrl%22%3A%22https%3A%2F%2Fcart.jlcpcb.com%2Fquote%2F%3ForderType%3D1%26stencilLayer%3D4%26stencilWidth%3D100%26stencilLength%3D100%26stencilCounts%3D5%22%7D; nowMoneyName=%24; iconCountryExchangeRateFlag=USD; nowExchangeRate=1; jlc_customer_code=2661708A; jlc_session_code=WAltRd7HdyLUQcvYRIzynA%3D%3D; client_login_info=%7B%22login_time%22%3A%222023-11-30+09%3A35%3A05%22%2C%22customer_code%22%3A%222661708A%22%7D; __stripe_mid=9f5fff3e-2cdf-4c1c-ab74-139e3f3c7162d49717; isPay=1; JSESSIONID=3502FB6E4C66EA87BBDCB2B5CAFDF143; JLCPCB_SESSION_ID=6bbfcd3b-ae4f-4831-ad13-f5d056b53d69; nowMoneyName=$; nowExchangeRate=1; ONEKEYID=93cfcbd7-1a56-42c3-8712-8034f5b8fd36; XSRF-TOKEN=9137b50e-7297-4aff-93b9-0a82b2537e8b' -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: same-origin' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' -H 'TE: trailers' --data-raw '{"keyword":"","firstSortName":"'$component'","firstSortNameNew":"'$component'","firstSortId":"","currentPage":1,"pageSize":500,"searchSource":"search","componentAttributes":[],"componentLibraryType":"base","preferredComponentFlag":true,"stockFlag":null,"stockSort":null,"componentBrand":null,"componentSpecification":null}' > pages/$component_noslash.json
        if [ $? -ne 0 ]; then
            # if curl fails, try again immediately
            continue
        fi

        # If a 200-code isn't present, remove the file and try again
        if ! grep -q '"code":200' pages/$component_noslash.json; then
            echo -n "Forrupt file. Trying again. File type: "
            file pages/$component_noslash.json
            rm pages/$component_noslash.json
            continue
        fi

        break
    done

    if [ $tries -eq 5 ]; then
        echo "Failed to download $component"
    fi
done
