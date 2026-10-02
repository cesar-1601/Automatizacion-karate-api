package com.dinersclub.integracion;

import java.nio.charset.StandardCharsets;
import java.security.KeyFactory;
import java.security.PublicKey;
import java.security.SecureRandom;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;

public final class CryptoUtils {

    private static final int IV_LENGTH = 12;
    private static final int TAG_LENGTH = 128;

    private CryptoUtils() {
    }

    public static String generateAesKeyBase64() throws Exception {
        KeyGenerator generator = KeyGenerator.getInstance("AES");
        generator.init(256);
        return Base64.getEncoder().encodeToString(generator.generateKey().getEncoded());
    }

    public static String encryptGcm(String plainText, String aesKeyBase64) throws Exception {
        byte[] iv = new byte[IV_LENGTH];
        new SecureRandom().nextBytes(iv);
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        cipher.init(Cipher.ENCRYPT_MODE, aesKey(aesKeyBase64), new GCMParameterSpec(TAG_LENGTH, iv));
        byte[] encrypted = cipher.doFinal(plainText.getBytes(StandardCharsets.UTF_8));
        byte[] result = new byte[iv.length + encrypted.length];
        System.arraycopy(iv, 0, result, 0, iv.length);
        System.arraycopy(encrypted, 0, result, iv.length, encrypted.length);
        return Base64.getEncoder().encodeToString(result);
    }

    public static String decryptGcm(String cipherTextBase64, String aesKeyBase64) throws Exception {
        byte[] input = Base64.getDecoder().decode(cipherTextBase64);
        byte[] iv = new byte[IV_LENGTH];
        byte[] encrypted = new byte[input.length - IV_LENGTH];
        System.arraycopy(input, 0, iv, 0, IV_LENGTH);
        System.arraycopy(input, IV_LENGTH, encrypted, 0, encrypted.length);
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        cipher.init(Cipher.DECRYPT_MODE, aesKey(aesKeyBase64), new GCMParameterSpec(TAG_LENGTH, iv));
        return new String(cipher.doFinal(encrypted), StandardCharsets.UTF_8);
    }

    public static String encryptAesKeyWithRsa(String aesKeyBase64, String publicKeyBase64) throws Exception {
        PublicKey publicKey = KeyFactory.getInstance("RSA").generatePublic(
            new X509EncodedKeySpec(Base64.getDecoder().decode(publicKeyBase64))
        );
        Cipher cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding");
        cipher.init(Cipher.ENCRYPT_MODE, publicKey);
        return Base64.getEncoder().encodeToString(cipher.doFinal(aesKeyBase64.getBytes(StandardCharsets.UTF_8)));
    }

    private static SecretKey aesKey(String aesKeyBase64) {
        return new SecretKeySpec(Base64.getDecoder().decode(aesKeyBase64), "AES");
    }
}