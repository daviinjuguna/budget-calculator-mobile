const ACCESS_TOKENS = "token";

const DEVELOPMENT = 'dev';
const PRODUCTION = 'prod';

const BASE_URL = "budget-f.herokuapp.com";
// const BASE_URL = "192.168.43.22:9000";

const PASS_REGEX = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$';
const NAME_REGEX = r"^[a-zA-Z]{2,30}$";
const PHONE_REGEX = r'^\+?1?\d{9,14}$';
const MONEY_REGEX = r'(\Ksh[0-9,]+(\.[0-9]{2})?)';
const KASH_REGEX = '[^0-9.]';

const MPESA = "MPESA";
const RECEIVE = "received";

const BOUGHT = "bought";
const SENT = "sent";
const AMWITHDRAW = "AMWithdraw";
const PMWITHDRAW = "PMWITHDRAW";

// void main() {
//   final _const = "You have received Ksh6,000.91, remaining is Ksh5,000.00";
  // final _extractKash = RegExp(REG_EX, multiLine: true);
  // final _kash = _extractKash.stringMatch(_const);
  // final _num = _kash?.replaceAll(RegExp('[^0-9.]'), '');

//   print(_extractKash);
//   print(_kash);
//   print(_num);
// }

// const REG_EX = r'(\Ksh[0-9,]+(\.[0-9]{2})?)';

