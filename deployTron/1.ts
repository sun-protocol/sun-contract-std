const TronWeb = require('tronweb')

/** 將 Tron base58 或 hex 轉成 ethers 可用的 0x 開頭 40 位 hex */
function toEthersAddress(addr: string) {
  if (!addr) return addr
  const s = String(addr).trim()
  if (/^0x[0-9a-fA-F]{40}$/.test(s)) return s
  if (s.startsWith('T')) {
    let hex = TronWeb.address.toHex(s)
    if (hex.startsWith('0x')) hex = hex.slice(2)
    // Tron toHex 回傳 41 + 40 字元，Solidity address 需 20 bytes，去掉 41 前綴
    if (hex.length === 42 && hex.startsWith('41')) hex = hex.slice(2)
    return '0x' + hex
  }
  if (/^[0-9a-fA-F]{40}$/.test(s)) return '0x' + s
  return s
}

module.exports = async ({ getNamedAccounts, deployments, getChainId, getUnnamedAccounts }) => {
  const { deploy } = deployments
  const { deployer } = await getNamedAccounts()

  //TODO: give the asset token address here
  const raw = 'INIT_ASSET_TOKEN'
  const assetToken = toEthersAddress(raw)

  const res = await deploy('SSPSafeVault', {
    from: deployer,
    gasLimit: 4000000,
    args: [assetToken],
    tags: 'SSPSafeVault',
  })
  console.log(res)
}

module.exports.tags = ['vault']
