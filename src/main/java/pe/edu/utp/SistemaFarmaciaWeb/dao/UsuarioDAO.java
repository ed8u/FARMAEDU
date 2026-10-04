package pe.edu.utp.SistemaFarmaciaWeb.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import pe.edu.utp.SistemaFarmaciaWeb.modelo.Usuario;
import pe.edu.utp.SistemaFarmaciaWeb.config.ConexionDB;

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

    public List<Usuario> listarActivos() {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT id_usuario, usuario, password, rol, nombres_completos, estado " +
                     "FROM Usuarios WHERE estado = 1 ORDER BY nombres_completos ASC";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Usuario u = new Usuario();
                u.setIdUsuario(rs.getInt("id_usuario"));
                u.setUsuario(rs.getString("usuario"));
                u.setPassword(rs.getString("password"));
                u.setRol(rs.getString("rol"));
                u.setNombresCompletos(rs.getString("nombres_completos"));
                u.setEstado(rs.getBoolean("estado"));
                lista.add(u);
            }
        } catch (Exception e) {
            System.err.println("Error al listar usuarios: " + e.getMessage());
        }
        return lista;
    }

    public boolean registrar(Usuario u) {
        String sql = "INSERT INTO Usuarios (usuario, password, rol, nombres_completos) VALUES (?, ?, ?, ?)";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, u.getUsuario());
            ps.setString(2, u.getPassword());
            ps.setString(3, u.getRol());
            ps.setString(4, u.getNombresCompletos());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error al registrar usuario: " + e.getMessage());
            return false;
        }
    }

    public boolean actualizar(Usuario u) {
        String sql = "UPDATE Usuarios SET usuario=?, password=?, rol=?, nombres_completos=? WHERE id_usuario=?";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, u.getUsuario());
            ps.setString(2, u.getPassword());
            ps.setString(3, u.getRol());
            ps.setString(4, u.getNombresCompletos());
            ps.setInt(5, u.getIdUsuario());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error al actualizar usuario: " + e.getMessage());
            return false;
        }
    }

    public boolean eliminarLogico(int idUsuario) {
        String sql = "UPDATE Usuarios SET estado = 0 WHERE id_usuario = ?";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error al eliminar usuario: " + e.getMessage());
            return false;
        }
    }
}