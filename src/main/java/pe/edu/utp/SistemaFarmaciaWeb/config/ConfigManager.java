package pe.edu.utp.SistemaFarmaciaWeb.config;

import java.io.InputStream;
import java.util.Properties;

public class ConfigManager {

    private static final Properties properties = new Properties();

    static {
        try (InputStream input = Thread.currentThread().getContextClassLoader().getResourceAsStream("db.properties")) {
            if (input != null) {
                properties.load(input);
            } else {
                System.err.println("[ERROR] No se encontró el archivo db.properties en el classpath.");
            }
        } catch (Exception e) {
            System.err.println("[ERROR] Fallo al cargar db.properties: " + e.getMessage());
        }
    }

    public static String getProperty(String key) {
        return properties.getProperty(key);
    }
}