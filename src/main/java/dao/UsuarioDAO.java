/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import config.ConexionDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import modelo.Usuario;

public class UsuarioDAO {
    
    public Usuario validar(String user, String pass) {
        Usuario usr = null;
        // Consulta SQL para verificar credenciales y estado activo
        String sql = "SELECT * FROM Usuarios WHERE username = ? AND password = ? AND estado = 1";
        
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, user);
            ps.setString(2, pass);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    usr = new Usuario();
                    usr.setIdUsuario(rs.getInt("id_usuario"));
                    usr.setIdRol(rs.getInt("id_rol"));
                    usr.setNombres(rs.getString("nombres"));
                    usr.setApellidos(rs.getString("apellidos"));
                    usr.setUsername(rs.getString("username"));
                    usr.setPassword(rs.getString("password"));
                    usr.setEstado(rs.getBoolean("estado"));
                }
            }
        } catch (Exception e) {
            System.out.println("Error al validar usuario: " + e.getMessage());
        }
        return usr;
    }
}