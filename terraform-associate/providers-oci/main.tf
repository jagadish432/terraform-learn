terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "4.100.0"
    }
  }
}

variable "compartment_id" {
  description = "OCID from your tenancy page"
  type        = string
  default = "ocid1.tenancy.oc1..aaaaaaaam3x2zsf4pfgs5rkjkingnv7bt2s5smzf66bzh4vz7ieke2pfdapq"
}

variable "ubu2004_image_source_ocid" {
  description = "ubuntu20.04  image source OCID for hyderabad region"
  type = string
  default = "ocid1.image.oc1.ap-hyderabad-1.aaaaaaaanvj7owsyhqs6qhlbpbhzketnhuky3vzezzhgcpms55tlsamb6vea"
}

provider "oci" {
  region              = "ap-hyderabad-1"
  auth                = "SecurityToken"
  config_file_profile = "personal"
}

resource "oci_core_vcn" "vcn_tf" {
  dns_label      = "internal"
  cidr_block     = "10.0.0.0/16"
  compartment_id = var.compartment_id
  display_name   = "My internal VCN - TF"
}

resource "oci_core_subnet" "subnet_tf" {
  vcn_id                     = oci_core_vcn.vcn_tf.id
  cidr_block                 = "10.0.1.0/24"
  compartment_id             = var.compartment_id
  display_name               = "subnet - TF"
  prohibit_public_ip_on_vnic = false
  dns_label                  = "dev"
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

resource "oci_core_instance" "ubuntu_instance" {
    # Required
    availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
    compartment_id = var.compartment_id
    shape = "VM.Standard.E2.1.Micro"
    source_details {
        source_id = var.ubu2004_image_source_ocid
        source_type = "image"
    }

    # Optional
    display_name = "testing_via_tf"
    create_vnic_details {
        assign_public_ip = true
        subnet_id = oci_core_subnet.subnet_tf.id
    }
    # metadata = {
    # ssh_authorized_keys = file("/Users/jdachepa/.oci/oci_api_key_public.pem")
	# }
    preserve_boot_volume = false
}

