package modelo;

import java.sql.Timestamp;

/**
 * Modelo de Favorito
 */
public class Favorito {
    private int idFavorito;
    private int idUsuario;
    private int idReceta;
    private Timestamp fechaAgregado;

    public Favorito() {}

    public Favorito(int idUsuario, int idReceta) {
        this.idUsuario = idUsuario;
        this.idReceta = idReceta;
    }

    // Getters y Setters
    public int getIdFavorito() {
        return idFavorito;
    }

    public void setIdFavorito(int idFavorito) {
        this.idFavorito = idFavorito;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public int getIdReceta() {
        return idReceta;
    }

    public void setIdReceta(int idReceta) {
        this.idReceta = idReceta;
    }

    public Timestamp getFechaAgregado() {
        return fechaAgregado;
    }

    public void setFechaAgregado(Timestamp fechaAgregado) {
        this.fechaAgregado = fechaAgregado;
    }
}