// Burocracia
#include <linux/cdev.h>
#include <linux/fs.h>
#include <linux/device.h>
// ....
#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>

#include <linux/spinlock.h>
static struct class *clase_letras;
static struct cdev device;
dev_t major;

static int espaciosLibres = 3;
static struct spinlock_t spin;

ssize_t operacion_lectura(struct file *filp, char __user *data, size_t s, loff_t *off) {
  return 0;
}

ssize_t operacion_escritura(struct file *filp, const char __user *data, size_t s, loff_t *off) {
  return s;
}


//https://github.com/torvalds/linux/blob/master/drivers/char/mem.c#L443
static int operacion_open(struct inode *inode, struct file *filp) {
  spin_lock(&spin);
  if (espaciosLibres == 0) return -EPERM;
  espaciosLibres -= 1;
  spin_unlock(&spin);
  
	return 0;
}

// int (*release) (struct inode *, struct file *);
static int operacion_release(struct inode *inode, struct file *filp) {
  
	return 0;
}

static struct file_operations mis_operaciones = {
  .owner = THIS_MODULE,
  .read = operacion_lectura,
  .write = operacion_escritura,
  .open = operacion_open,
  .release = operacion_release,
};

static int __init init(void) {
  cdev_init(&device, &mis_operaciones); // Inicializarse como dispositivo
  alloc_chrdev_region(&major, 0, 1, "letras123");
  cdev_add(&device, major, 1);
  
  clase_letras = class_create(THIS_MODULE, "letras123");
  device_create(clase_letras, NULL, major, NULL, "letras123");
  
  spin_lock_init(&spin);
  
	printk(KERN_ALERT "Hola letras123!\n");
	return 0;
}

static void __exit exit(void) {
  unregister_chrdev_region(major, 1);
  cdev_del(&device);
  
  device_destroy(clase_letras, major);
  class_destroy(clase_letras);
  
  printk(KERN_ALERT "Adios letras123.\n");
}

module_init(init);
module_exit(exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("La banda de SO");
MODULE_DESCRIPTION("Una suerte de 'Hola, mundo'");
