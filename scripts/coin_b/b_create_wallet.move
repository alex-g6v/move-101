// sources/test_script.move
script {
use 0x3::CoinB;
fun b_create_wallet(account: signer) {
    CoinB::create_coin_wallet(&account);
}
}
