// Burocracia
#include <linux/cdev.h>
#include <linux/fs.h>
#include <linux/device.h>
// ....
#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/uaccess.h> // Acceso a data usuario
#include <linux/slab.h> // Memoria kernel
#include <linux/random.h>

static struct class *clase_azar;
static struct cdev device;
static dev_t major;

static int numero = 0;

ssize_t operacion_lectura(struct file *filp, char __user *data, size_t s, loff_t *off) {
  int num;
  int result;
  int buffer_size = s;
  
  get_random_bytes(&num, sizeof(int) - 1);
  result = (num % numero);
  
  char *buffer = kmalloc(buffer_size, GFP_KERNEL);
  int bytes_usados = snprintf(buffer, buffer_size, "%d\n", result);
  
  copy_to_user(data, buffer, bytes_usados);
  
  kfree(buffer);
  return bytes_usados;
}
  
ssize_t operacion_escritura(struct file *filp, const char __user *data, size_t s, loff_t *off) {
  char *texto = kmalloc(s + 1, GFP_KERNEL);
  copy_from_user(texto, data, s);
  texto[s] = '\0';

  if (kstrtoint(texto, 10, &numero)) {
    kfree(texto);
    return -EPERM;
  }
  
  kfree(texto);
  return s;
}

static struct file_operations mis_operaciones = {
  .owner = THIS_MODULE,
  .read = operacion_lectura,
  .write = operacion_escritura,
};

static int __init init(void) {
  cdev_init(&device, &mis_operaciones); // Inicializarse como dispositivo
  alloc_chrdev_region(&major, 0, 1, "azar");
  cdev_add(&device, major, 1);
  
  clase_azar = class_create(THIS_MODULE, "azar");
  device_create(clase_azar, NULL, major, NULL, "azar");
  
	printk(KERN_ALERT "Hola azar!\n");
	return 0;
}

static void __exit exit(void) {
  unregister_chrdev_region(major, 1);
  cdev_del(&device);
  
  device_destroy(clase_azar, major);
  class_destroy(clase_azar);
  
  
  
  printk(KERN_ALERT "Adios azar.\n");
}

module_init(init);
module_exit(exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("La banda de SO");
MODULE_DESCRIPTION("Una suerte de 'Hola, mundo'");
