// sources/test_script.move
script {
use 0x3::CoinB;
fun b_init(account: signer) {
    CoinB::give_coins(&account, @0xa, 50);
    CoinB::give_coins(&account, @0xb, 50);
    CoinB::give_coins(&account, @0xc, 50);
}
}