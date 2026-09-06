/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionDB {
    
    // Cadena de conexión hacia la base de datos que creamos
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=FarmaciaWI;encrypt=true;trustServerCertificate=true;";
    private static final String USER = "sa"; 
    private static final String PASS = "123456";

    public static Connection getConexion() {
        Connection con = null;
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            con = DriverManager.getConnection(URL, USER, PASS);
            System.out.println("¡Conexión Exitosa a FARMACIAWI!");
        } catch (ClassNotFoundException e) {
            System.out.println("Error: No se encontró el driver JDBC. " + e.getMessage());
        } catch (SQLException e) {
            System.out.println("Error SQL: Falló la conexión. " + e.getMessage());
        }
        return con;
    }
    
    // Método main solo para probar la conexión directamente
    public static void main(String[] args) {
        ConexionDB.getConexion();
    }
}