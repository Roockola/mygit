#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"

SERVICES_LIST(){

    RES=$($PSQL "select * from services")
    echo "$RES" | sed -E 's/\|/) /g'
}


  echo -e "\nWelcome to My Salon, how can I help you?\n"
  SERVICES_LIST
  read SERVICE_ID_SELECTED
  SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id =  $SERVICE_ID_SELECTED")
  while [[ -z $SERVICE_ID ]]
  do
    echo -e "\nI could not find that service. What would you like today?\n"
    SERVICES_LIST
    read SERVICE_ID_SELECTED
    SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id =  $SERVICE_ID_SELECTED")
  done
  #SERVICE FOUND
  SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID")
  echo -e "\nWhat's your phone number?\n"
  read CUSTOMER_PHONE
  CUS_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $CUS_ID ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?\n"
    read CUSTOMER_NAME
    echo -e "\nWhat time would you like your $SERVICE, $CUSTOMER_NAME?\n"
    read SERVICE_TIME
    INS_CUS=$($PSQL "insert into customers (name, phone) values ('$CUSTOMER_NAME', '$CUSTOMER_PHONE') RETURNING customer_id")
    INS_CUS_ID=$($PSQL "SELECT customer_id from customers WHERE phone = '$CUSTOMER_PHONE'")
    INS_APP=$($PSQL "insert into appointments (customer_id, service_id, time) values ($INS_CUS_ID, $SERVICE_ID, '$SERVICE_TIME')")
    
  else
    CUSTOMER_NAME=$($PSQL "select name from customers where phone = '$CUSTOMER_PHONE'")
    echo -e "\nWhat time would you like your $SERVICE, $CUSTOMER_NAME?\n"
    read SERVICE_TIME
    INS_APP=$($PSQL "insert into appointments (customer_id, service_id, time) values ($CUS_ID, $SERVICE_ID, '$SERVICE_TIME')")
  

  fi
  echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."