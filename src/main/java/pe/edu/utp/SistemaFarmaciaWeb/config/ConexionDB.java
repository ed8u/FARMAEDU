package pe.edu.utp.SistemaFarmaciaWeb.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionDB {

    public static Connection getConexion() {
        Connection con = null;
        try {
            Class.forName(ConfigManager.getProperty("db.driver"));
            con = DriverManager.getConnection(
                ConfigManager.getProperty("db.url.farma"), 
                ConfigManager.getProperty("db.user"), 
                ConfigManager.getProperty("db.password")
            );
        } catch (ClassNotFoundException e) {
            System.err.println("Error: No se encontró el driver JDBC de SQL Server.");
        } catch (SQLException e) {
            System.err.println("Error de conexión a la Base de Datos: " + e.getMessage());
        }
        return con;
    }
}