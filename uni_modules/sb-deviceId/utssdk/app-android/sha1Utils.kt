package com.yt.uniplugin_unique
import java.security.MessageDigest
/**
 * Description: Recycler
 * Author:     yangtong<br>
 * Date:    2025/1/17    10:25
 * Version:
 * Update:
 */
object YTUtils{
    fun sha1(mes:String):String{
        return try {
            val messageDigest = MessageDigest.getInstance("SHA1");
            val dataBytes = mes.toByteArray(Charsets.UTF_8);
            val hashBytes = messageDigest.digest(dataBytes);
            hashBytes.joinToString(""){"%02x".format(it)}
        }catch (e: Exception){
            e.printStackTrace()
            ""
        }
    }
}