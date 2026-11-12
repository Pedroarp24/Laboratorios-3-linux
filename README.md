# Prácticas de Linux: GRUB, Scripts y SSH con llaves

**Estudiante:** TU_NOMBRE
**Matrícula:** TU_MATRICULA
**Materia:** NOMBRE_MATERIA

Entorno: Linux Mint (basado en Ubuntu) en VirtualBox, con Windows como máquina host.

| Práctica | Tema | Video |
| --- | --- | --- |
| 1 | GRUB a 20 segundos y recuperación de la contraseña de root | ENLACE_VIDEO_1 |
| 2 | Scripts de backup con TAR y de ifconfig | ENLACE_VIDEO_2 |
| 3 | Modo bridge, SSH y autenticación con llaves | ENLACE_VIDEO_3 |

---

## Práctica 1: GRUB y recuperación de root

### Menú de GRUB con espera de 20 segundos

```bash
sudo sed -i 's/^GRUB_TIMEOUT_STYLE=.*/GRUB_TIMEOUT_STYLE=menu/; s/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=20/' /etc/default/grub
grep -r TIMEOUT /etc/default/grub /etc/default/grub.d/
sudo update-grub
sudo reboot
```

- `GRUB_TIMEOUT=20`: el menú espera 20 segundos.
- `GRUB_TIMEOUT_STYLE=menu`: el menú se muestra en lugar de estar oculto.

### Recuperar la contraseña de root

1. En el menú de GRUB, sobre **Linux Mint**, presionar `e`.
2. En la línea que empieza con `linux`, cambiar `ro quiet splash` por `rw init=/bin/bash`.
3. Presionar `Ctrl + X` para arrancar en una consola de root.
4. Cambiar la contraseña y continuar el arranque:

```bash
passwd root
sync
exec /sbin/init
```

5. Verificar el acceso:

```bash
su -
whoami
```

---

## Práctica 2: Scripts

### `backup.sh`

Crea un comprimido con TAR de `/home/<usuario>`. El nombre del archivo lleva la fecha y la hora en formato `dd-mm-yyyy:hh:mm`.

```bash
chmod +x backup.sh
./backup.sh
ls -l ~/backups
```

Ejemplo de resultado: `backup_11-11-2026:22:30.tar.gz`

Se usa `tar --force-local` porque, sin esa opción, tar interpreta los `:` del nombre como un servidor remoto.

### `red.sh`

Pregunta qué nombre se le quiere poner al archivo y guarda en el escritorio la salida de `ifconfig` con ese nombre.

```bash
sudo apt install net-tools -y
chmod +x red.sh
./red.sh
cat ~/Escritorio/NOMBRE.txt
```

---

## Práctica 3: Bridge, SSH y llaves

### 1. Modo bridge y ping

VirtualBox → Configuración de la VM → Red → Conectado a: **Adaptador puente** (Wi-Fi del host).

```bash
ip a                     # en la VM: obtener la IP
```

```powershell
ping IP_DE_LA_VM         # en Windows
```

### 2. Servicio SSH y conexión con contraseña

```bash
sudo apt install openssh-server -y
sudo systemctl enable --now ssh
```

```powershell
ssh usuario@IP_DE_LA_VM
```

### 3. Par de llaves en Windows (passphrase en blanco)

```powershell
ssh-keygen -t ed25519
# Destino: C:\Users\USUARIO_WINDOWS\.ssh\id_ed25519
# Passphrase: Enter dos veces (en blanco)
```

### 4. Copiar la llave pública al servidor

Windows no incluye `ssh-copy-id`, así que la llave se copia con:

```powershell
type $env:USERPROFILE\.ssh\id_ed25519.pub | ssh usuario@IP_DE_LA_VM "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
```

### 5. Prueba

```powershell
ssh usuario@IP_DE_LA_VM
```

Entra automáticamente, sin pedir credenciales.
