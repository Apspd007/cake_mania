const PAYMENT_URL = "http://10.0.2.2:5001/cake-mania-aa560/us-central1/paymentFunction/payment";

const ORDER_DATA = {
  "custID": "USER_1122334456",
  "custEmail": "someemai@gmail.com",
  "custPhone": "7777777789"
};

const STATUS_LOADING = "PAYMENT_LOADING";
const STATUS_SUCCESSFUL = "PAYMENT_SUCCESSFUL";
const STATUS_PENDING = "PAYMENT_PENDING";
const STATUS_FAILED = "PAYMENT_FAILED";
const STATUS_CHECKSUM_FAILED = "PAYMENT_CHECKSUM_FAILED";