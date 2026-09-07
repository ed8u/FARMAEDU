/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pe.edu.utp.SistemaFarmaciaWeb.config;

import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class InicializadorDB implements ServletContextListener {

    private static final String URL_MASTER = "jdbc:sqlserver://localhost:1433;databaseName=master;encrypt=false;trustServerCertificate=true;";
    private static final String URL_FARMAEDU = "jdbc:sqlserver://localhost:1433;databaseName=FarmaciaWI;encrypt=false;trustServerCertificate=true;";
    private static final String USER = "sa"; 
    private static final String PASS = "123456"; // Cambiar si la clave es distinta

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("=====================================================");
        System.out.println("Iniciando motor de base de datos FARMAEDU...");
        
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            
            // FASE 1: Crear la Base de Datos si no existe
            try (Connection conMaster = DriverManager.getConnection(URL_MASTER, USER, PASS);
                 Statement stmtMaster = conMaster.createStatement()) {
                
                String sqlCreateDB = "IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'FarmaciaWI') " +
                                     "BEGIN CREATE DATABASE FarmaciaWI; END";
                stmtMaster.execute(sqlCreateDB);
                System.out.println("[OK] Base de datos FarmaciaWI operativa.");
            }

            // FASE 2: Conectar a FarmaciaWI y crear las tablas si el entorno está vacío
            try (Connection conFarma = DriverManager.getConnection(URL_FARMAEDU, USER, PASS);
                 Statement stmtFarma = conFarma.createStatement()) {
                
                // Verificamos si la tabla Usuarios existe para saber si la BD está vacía
                boolean tablasExisten = false;
                String checkTable = "SELECT COUNT(*) as existe FROM sys.tables WHERE name = 'Usuarios'";
                try (ResultSet rs = stmtFarma.executeQuery(checkTable)) {
                    if (rs.next() && rs.getInt("existe") > 0) {
                        tablasExisten = true;
                    }
                }

                if (!tablasExisten) {
                    System.out.println("[INFO] Entorno vacío detectado. Construyendo arquitectura de tablas...");
                    
                    // Leer el archivo script_FARMACIAWI.sql desde la carpeta WEB-INF
                    InputStream is = sce.getServletContext().getResourceAsStream("/WEB-INF/script_db_farmacia.sql");
                    
                    if (is != null) {
                        String scriptCompleto = new String(is.readAllBytes(), StandardCharsets.UTF_8);
                        
                        // Separar el script en bloques eliminando la palabra "GO"
                        String[] comandos = scriptCompleto.split("(?i)\\bGO\\b");
                        
                        for (String comando : comandos) {
                            if (!comando.trim().isEmpty()) {
                                stmtFarma.execute(comando);
                            }
                        }
                        System.out.println("[OK] Arquitectura de tablas y datos semilla creados con éxito.");
                    } else {
                        System.out.println("[ERROR] No se encontró el archivo script_FARMACIAWI.sql en WEB-INF.");
                    }
                } else {
                    System.out.println("[OK] Estructura de tablas validada. No se requieren cambios.");
                }
            }
            
        } catch (Exception e) {
            System.err.println("[ERROR CRÍTICO] Fallo en la inicialización: " + e.getMessage());
        }
        System.out.println("=====================================================");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("Apagando sistema FARMAEDU. Liberando recursos...");
    }
}