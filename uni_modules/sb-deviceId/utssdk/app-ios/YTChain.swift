import Foundation
import CoreFoundation
class YTChain{
    private let DeviceUUIDKey:String = "uuid_chain"
    private static var service_String:String = Bundle.main.bundleIdentifier ?? "com.dcloud.www"
    // 数据属性
    private var chainData: [String: Any]?
    static let shared = {
        let instance = YTChain()
        instance.initDatas()
        return instance
    }();
    
    private init() {
         
    }
    
    //对外暴露的api
    func getDeviceIdentifier()->String{
        if self.chainData != nil {
            return self.chainData?[DeviceUUIDKey] as! String;
        }
        return "";
    }
    
    private func initDatas(){
        if let datas = YTChain.loadDatas(), datas is [String: Any] {
            self.chainData = datas as? [String: Any]
        } else {
            // 如果数据不存在，则生成
            let datas = [DeviceUUIDKey: YTChain.NA_UUIDString()]
            YTChain.saveAntHouseData(datas)
            self.chainData = datas
        }
    }
    private class func loadDatas() -> Any? {
        let userDefaults = UserDefaults.standard
        var info = userDefaults.object(forKey: service_String) // 先从 UserDefaults 取出来
        
        if info == nil {
            info = self.load(service: service_String) // 如果没取到，从秘钥链里面取
            if let info = info {
                userDefaults.set(info, forKey: service_String)
                userDefaults.synchronize()
            }
        }
        
        var data: Any?
        if let info = info as? [String: Any] {
            if let key = info.keys.first {
                data = info[key]
            }
        }
        
        return data
    }
    
    // 生成 UUID 并移除 "-"，转换为小写
    private class func NA_UUIDString() -> String {
        let uuid = CFUUIDCreate(kCFAllocatorDefault)
        let uuidString = CFUUIDCreateString(kCFAllocatorDefault, uuid) as String? ?? ""
        // 移除 "-" 并转换为小写
        let formattedUUID = uuidString.replacingOccurrences(of: "-", with: "").lowercased()
        return formattedUUID
    }
    
    private class func load(service: String) -> Any? {
        var ret: Any?
        var keychainQuery = self.getKeychainQuery(service: service)
        
        // 配置搜索设置
        keychainQuery[kSecReturnData as String] = kCFBooleanTrue
        keychainQuery[kSecMatchLimit as String] = kSecMatchLimitOne
        
        var keyData: CFTypeRef?
        let status = SecItemCopyMatching(keychainQuery as CFDictionary, &keyData)
        
        if status == errSecSuccess, let keyData = keyData as? Data {
            do {
                // 解档数据
                if let unarchivedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(keyData) {
                    ret = unarchivedData
                }
            } catch {
                print("Unarchive of \(service) failed: \(error)")
            }
        }
        
        return ret
    }
    
    private class func getKeychainQuery(service: String) -> [String: Any] {
        return [
            kSecClass as String: kSecClassGenericPassword, // 类型为通用密码
            kSecAttrService as String: service, // 服务名称
            kSecAttrAccount as String: service, // 账户名称
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock // 可访问性
        ]
    }
    private class func save(service: String, data: Any) {
        // 获取 Keychain 查询字典
        var keychainQuery = self.getKeychainQuery(service: service)
        
        // 删除旧的 Keychain 项
        SecItemDelete(keychainQuery as CFDictionary)
        
        // 将数据归档为 Data
        guard let archivedData = try? NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false) else {
            print("Failed to archive data")
            return
        }
        
        // 添加新数据到查询字典
        keychainQuery[kSecValueData as String] = archivedData
        
        // 将新数据添加到 Keychain
        let status = SecItemAdd(keychainQuery as CFDictionary, nil)
        if status != errSecSuccess {
            print("Failed to save data to Keychain: \(status)")
        }
    }
    private class func saveAntHouseData(_ data: Any) {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            print("Failed to get bundle identifier")
            return
        }
        
        let dict: [String: Any] = [bundleId: data]
        
        // 保存到 UserDefaults
        UserDefaults.standard.set(dict, forKey: service_String)
        UserDefaults.standard.synchronize()
        
        // 保存到 Keychain
        self.save(service: service_String, data: dict)
    }
}