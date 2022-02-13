// sources/test_script.move
script {
use 0x3::CoinA;
fun a_init(account: signer) {
    CoinA::init(&account);
    CoinA::give_coins(&account, @0xa, 50);
    CoinA::give_coins(&account, @0xb, 50);
    CoinA::give_coins(&account, @0xc, 50);
}
}