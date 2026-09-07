/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pe.edu.utp.SistemaFarmaciaWeb.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import pe.edu.utp.SistemaFarmaciaWeb.config.ConexionDB;
import pe.edu.utp.SistemaFarmaciaWeb.modelo.Usuario;

public class UsuarioDAO {

    public Usuario validar(String username, String pass) {
        Usuario usr = null;
        String sql = "SELECT id_usuario, usuario, password, rol, nombres_completos, estado " +
                     "FROM Usuarios WHERE usuario = ? AND password = ? AND estado = 1";

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, pass);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    usr = new Usuario();
                    usr.setIdUsuario(rs.getInt("id_usuario"));
                    usr.setUsuario(rs.getString("usuario"));
                    usr.setPassword(rs.getString("password"));
                    usr.setRol(rs.getString("rol"));
                    usr.setNombresCompletos(rs.getString("nombres_completos"));
                    usr.setEstado(rs.getBoolean("estado"));
                }
            }
        } catch (Exception e) {
            System.err.println("Error al validar usuario: " + e.getMessage());
        }
        return usr;
    }
}