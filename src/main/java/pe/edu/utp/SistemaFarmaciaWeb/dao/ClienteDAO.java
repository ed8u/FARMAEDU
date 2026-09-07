/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pe.edu.utp.SistemaFarmaciaWeb.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import pe.edu.utp.SistemaFarmaciaWeb.config.ConexionDB;
import pe.edu.utp.SistemaFarmaciaWeb.modelo.Cliente;

public class ClienteDAO {

    public List<Cliente> listarActivos() {
        List<Cliente> lista = new ArrayList<>();
        String sql = "SELECT id_cliente, tipo_documento, dni_ruc, nombres_rsocial, email, " +
                     "telefono, direccion, fecha_registro, estado " +
                     "FROM Clientes WHERE estado = 1 ORDER BY nombres_rsocial ASC";

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Cliente c = new Cliente();
                c.setIdCliente(rs.getInt("id_cliente"));
                c.setTipoDocumento(rs.getString("tipo_documento"));
                c.setDniRuc(rs.getString("dni_ruc"));
                c.setNombresRsocial(rs.getString("nombres_rsocial"));
                c.setEmail(rs.getString("email"));
                c.setTelefono(rs.getString("telefono"));
                c.setDireccion(rs.getString("direccion"));
                
                Timestamp ts = rs.getTimestamp("fecha_registro");
                if (ts != null) {
                    c.setFechaRegistro(ts.toLocalDateTime());
                }
                c.setEstado(rs.getBoolean("estado"));
                lista.add(c);
            }
        } catch (Exception e) {
            System.err.println("Error al listar clientes: " + e.getMessage());
        }
        return lista;
    }

    public boolean registrar(Cliente c) {
        String sql = "INSERT INTO Clientes (tipo_documento, dni_ruc, nombres_rsocial, email, telefono, direccion) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, c.getTipoDocumento());
            ps.setString(2, c.getDniRuc());
            ps.setString(3, c.getNombresRsocial());
            ps.setString(4, c.getEmail());
            ps.setString(5, c.getTelefono());
            ps.setString(6, c.getDireccion());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error al registrar cliente: " + e.getMessage());
            return false;
        }
    }

    public boolean actualizar(Cliente c) {
        String sql = "UPDATE Clientes SET tipo_documento=?, dni_ruc=?, nombres_rsocial=?, email=?, " +
                     "telefono=?, direccion=? WHERE id_cliente=?";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, c.getTipoDocumento());
            ps.setString(2, c.getDniRuc());
            ps.setString(3, c.getNombresRsocial());
            ps.setString(4, c.getEmail());
            ps.setString(5, c.getTelefono());
            ps.setString(6, c.getDireccion());
            ps.setInt(7, c.getIdCliente());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error al actualizar cliente: " + e.getMessage());
            return false;
        }
    }

    // Borrado lógico para proteger integridad
    public boolean eliminarLogico(int idCliente) {
        String sql = "UPDATE Clientes SET estado = 0 WHERE id_cliente = ?";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idCliente);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error al eliminar cliente: " + e.getMessage());
            return false;
        }
    }
}