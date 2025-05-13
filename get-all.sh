#!/bin/sh
mkdir -p pages
export IFS='|'

# components=$(curl -s https://jlcpcb.com/parts/basic_parts | sed 's/</\n/g' | grep -A 99999999 'All Components' | sed '/Reset All/q' | grep whitespace-nowrap  | cut -d'>' -f2 | sed 's/\&amp;/\&/g' | tr '\n' '|')

# components="Amplifiers/Comparators|Audio Products / Vibration Motors|Capacitors|Circuit Protection|Clock/Timing|Connectors|Crystals, Oscillators, Resonators|Data Acquisition|Diodes|Displays|Electronic Tools/Instruments/Consumables|Embedded Processors & Controllers|Filters|Global Sourcing Parts|Inductors, Coils, Chokes|Interface|IoT/Communication Modules|LED Drivers|Logic|Memory|Motor Driver ICs|Optocouplers & LEDs & Infrared|Optoelectronics|Optoisolators|Power Management (PMIC)|Power Management ICs|Power Modules|Relays|Resistors|RF And Wireless|Sensors|Signal Isolation Devices|Switches|Transistors/Thyristors|Triode/MOS Tube/Transistor"
components="Optoelectronics|Sensors|Switches"
failed_components=""
for component in $components
do
    component_noslash=$(echo $component | tr / .)
    echo "Downloading $component"
    for tries in 1 2 3 4 5 6 7 8 9 10
    do
        curl 'https://jlcpcb.com/api/overseas-pcb-order/v1/shoppingCart/smtGood/selectSmtComponentList/v2' -X POST -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:130.0) Gecko/20100101 Firefox/130.0' -H 'Accept: application/json, text/plain, */*' -H 'Accept-Language: en-GB,en;q=0.5' -H 'Accept-Encoding: gzip, deflate, br, zstd' -H 'Content-Type: application/json' -H 'X-XSRF-TOKEN: b6159077-d303-465c-ab2e-2aa9bd53c868' -H 'Origin: https://jlcpcb.com' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Referer: https://jlcpcb.com/parts/all-electronic-components' -H 'Cookie: _ga_XDWD4D52RC=GS1.1.1725902337.70.0.1725902337.60.0.0; _ga=GA1.1.1196587209.1716422120; _yjsu_yjad=1716422120.e5e8ed66-ac6a-4b84-83ee-b62972458b61; sensorsdata2015jssdkcross=%7B%22distinct_id%22%3A%2218fa2bb1a002f8-0a24df5770b96a8-e505625-3686400-18fa2bb1a01cf0%22%2C%22first_id%22%3A%22%22%2C%22props%22%3A%7B%22%24latest_traffic_source_type%22%3A%22%E7%9B%B4%E6%8E%A5%E6%B5%81%E9%87%8F%22%2C%22%24latest_search_keyword%22%3A%22%E6%9C%AA%E5%8F%96%E5%88%B0%E5%80%BC_%E7%9B%B4%E6%8E%A5%E6%89%93%E5%BC%80%22%2C%22%24latest_referrer%22%3A%22%22%7D%2C%22identities%22%3A%22eyIkaWRlbnRpdHlfY29va2llX2lkIjoiMThmYTJiYjFhMDAyZjgtMGEyNGRmNTc3MGI5NmE4LWU1MDU2MjUtMzY4NjQwMC0xOGZhMmJiMWEwMWNmMCJ9%22%2C%22history_login_id%22%3A%7B%22name%22%3A%22%22%2C%22value%22%3A%22%22%7D%2C%22%24device_id%22%3A%2218fa2bb1a002f8-0a24df5770b96a8-e505625-3686400-18fa2bb1a01cf0%22%7D; tfstk=f17jiKsh_xDf2nWIdnFyRBh0cnYNhOaUhfOOt13q6ELA6F1OsdJ2bdS7fTXMQZrG6d61ULbvHO8qCP6Wkhj2QKJ651XCcJzU8sfDSheULylE9t-wkIdvWCFteCRUlb2JfsfDSb2ULyzFicZeWZ2XWOURwBJ-DxB9BbFW6CkxXqBOw7OMecn9WIK-2IR9MfKqFCrX6sN5T_ypCSWdMLgItaAR6mfDFV3OP2-XpepSWVQWi_htyPuQbpIH3HJcezuX5_d13LWLJ4TJAMfw1tajkESRqZYVzJMwcO992ZBbhmvA0TtHw3h_-QWeesbAV5DRM9JXPMQa_V9dv1Qvcg4nHdSPONO1SR45d6blFQBL5-IzD2JCD8osNH09NmV7NcmNPLYH-kxeywKvZIUUN7MSjndkNIN7Nc7WDQAvp7NSnDC..; jlc_customer_code=2661708A; jlc_session_code=WAltRd7HdyLUQcvYRIzynA%3D%3D; client_login_info=%7B%22login_time%22%3A%222024-08-10+10%3A57%3A32%22%2C%22customer_code%22%3A%222661708A%22%7D; _ga_VB33MLCQS2=GS1.1.1724046347.43.0.1724046353.0.0.0; _ga_BZ8D96C9TK=GS1.1.1724046347.43.0.1724046353.0.0.0; traceUrl=%7B%22advertisingUrl%22%3A%22https%3A%2F%2Fjlcpcb.com%2F%22%2C%22websiteUrl%22%3A%22https%3A%2F%2Fcart.jlcpcb.com%2Fquote%3ForderType%3D1%26stencilLayer%3D2%26stencilWidth%3D100%26stencilLength%3D100%26stencilCounts%3D5%22%7D; jlc_s=A; JSESSIONID=87D08AEFE9678A25260416BFD61D613D; JLCPCB_SESSION_ID=a41dd667-c3d6-446d-ad96-01aa26a5abee; nowMoneyName=$; nowExchangeRate=1; languageCode=en; iconCountryFlag=SG; iconCountryExchangeRateFlag=USD; acw_tc=20b9a5f1f34b8788d63ddaa52d1c3a8ba471ea492546e73f053ac7ee7b01c99a; XSRF-TOKEN=b6159077-d303-465c-ab2e-2aa9bd53c868' -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: same-origin' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' --data-raw '{"currentPage":1,"pageSize":8000,"componentLibraryType":null,"stockFlag":false,"stockSort":null,"firstSortName":"'$component'","componentBrandList":[],"componentSpecificationList":[],"componentAttributeList":[],"paramList":[],"startStockNumber":null,"endStockNumber":null,"firstSortNameNew":"'$component'","searchSource":"search"}' > "pages/$component_noslash.json"
        if [ $? -ne 0 ]; then
            # if curl fails, try again immediately
            continue
        fi

        # If a 200-code isn't present, remove the file and try again
        if ! grep -q '"code":200' "pages/$component_noslash.json"; then
            echo -n "Corrupt file. Trying again. File type: "
            file "pages/$component_noslash.json" | tr '\n' ' - '
            ls -lh "pages/$component_noslash.json"
            rm -f "pages/$component_noslash.json"
            sleep $tries
            continue
        fi

        break
    done

    if [ $tries -eq 5 ]; then
        echo "Failed to download $component"
        if [ "$failed_components" != "" ]; then
            failed_components="$failed_components, "
        fi
        failed_components="$failed_components$component"
    fi
done

if [ "$failed_components" != "" ]; then
    echo "Failed to download the following components: $failed_components"
fi
