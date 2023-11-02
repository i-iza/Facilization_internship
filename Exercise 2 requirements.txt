CREATE TABLE IZABORA_currency_exchange_rate(
  currency_name VARCHAR2(3),
  to_currency VARCHAR2(3) DEFAULT 'EUR',
  exchange_rate NUMBER(24,12),
  date_of_rate DATE
);