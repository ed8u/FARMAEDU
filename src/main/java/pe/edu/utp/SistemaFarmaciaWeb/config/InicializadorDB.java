package pe.edu.utp.SistemaFarmaciaWeb.config;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class InicializadorDB implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("=====================================================");
        System.out.println("Iniciando motor de base de datos FARMAEDU...");

        String driver = ConfigManager.getProperty("db.driver");
        String urlMaster = ConfigManager.getProperty("db.url.master");
        String urlFarma = ConfigManager.getProperty("db.url.farma");
        String user = ConfigManager.getProperty("db.user");
        String pass = ConfigManager.getProperty("db.password");

        if (driver == null || urlMaster == null) {
            System.err.println("[ERROR CRÍTICO] Las propiedades de base de datos no están disponibles.");
            return;
        }

        try {
            Class.forName(driver);

            // FASE 1: Crear la Base de Datos si no existe
            try (Connection conMaster = DriverManager.getConnection(urlMaster, user, pass);
                 Statement stmtMaster = conMaster.createStatement()) {

                String sqlCreateDB = "IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'FarmaciaWI') " +
                                     "BEGIN CREATE DATABASE FarmaciaWI; END";
                stmtMaster.execute(sqlCreateDB);
                System.out.println("[OK] Base de datos FarmaciaWI operativa.");
            }

            // FASE 2: Conectar a FarmaciaWI y crear las tablas
            try (Connection conFarma = DriverManager.getConnection(urlFarma, user, pass);
                 Statement stmtFarma = conFarma.createStatement()) {

                boolean tablasExisten = false;
                String checkTable = "SELECT COUNT(*) as existe FROM sys.tables WHERE name = 'Usuarios'";
                try (ResultSet rs = stmtFarma.executeQuery(checkTable)) {
                    if (rs.next() && rs.getInt("existe") > 0) {
                        tablasExisten = true;
                    }
                }

                if (!tablasExisten) {
                    System.out.println("[INFO] Entorno vacío detectado. Construyendo arquitectura de tablas...");

                    InputStream is = sce.getServletContext().getResourceAsStream("/WEB-INF/script_db_farmacia.sql");

                    if (is != null) {
                        String scriptCompleto = new String(is.readAllBytes(), StandardCharsets.UTF_8);
                        String[] comandos = scriptCompleto.split("(?i)\\bGO\\b");

                        for (String comando : comandos) {
                            if (!comando.trim().isEmpty()) {
                                stmtFarma.execute(comando);
                            }
                        }
                        System.out.println("[OK] Arquitectura de tablas y datos semilla creados con éxito.");
                    } else {
                        System.out.println("[ERROR] No se encontró script_db_farmacia.sql en WEB-INF.");
                    }
                } else {
                    System.out.println("[OK] Estructura de tablas validada. No se requieren cambios.");
                }
            }

        } catch (IOException | ClassNotFoundException | SQLException e) {
            System.err.println("[ERROR CRÍTICO] Fallo en la inicialización: " + e.getMessage());
        }
        System.out.println("=====================================================");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("Apagando sistema FARMAEDU. Liberando recursos...");
    }
}