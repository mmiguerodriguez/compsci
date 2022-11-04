// Burocracia
#include <linux/cdev.h>
#include <linux/fs.h>
#include <linux/device.h>
// ....
#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>

static struct class *clase_nulo;
static struct cdev device;
dev_t major;

ssize_t operacion_lectura(struct file *filp, char __user *data, size_t s,
loff_t *off) {
  return 0;
}

ssize_t operacion_escritura(struct file *filp, const char __user *data, size_t s, loff_t *off) {
  return s;
}

static struct file_operations mis_operaciones = {
  .owner = THIS_MODULE,
  .read = operacion_lectura,
  .write = operacion_escritura,
};

static int __init init(void) {
  cdev_init(&device, &mis_operaciones); // Inicializarse como dispositivo
  alloc_chrdev_region(&major, 0, 1, "nulo");
  cdev_add(&device, major, 1);
  
  clase_nulo = class_create(THIS_MODULE, "nulo");
  device_create(clase_nulo, NULL, major, NULL, "nulo");
  
	printk(KERN_ALERT "Hola dev_nulo!\n");
	return 0;
}

static void __exit exit(void) {
  unregister_chrdev_region(major, 1);
  cdev_del(&device);
  
  device_destroy(clase_nulo, major);
  class_destroy(clase_nulo);
  
  printk(KERN_ALERT "Adios dev_nulo.\n");
}

module_init(init);
module_exit(exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("La banda de SO");
MODULE_DESCRIPTION("Una suerte de 'Hola, mundo'");
