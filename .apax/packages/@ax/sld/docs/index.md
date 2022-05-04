# Loader (sld)

The `sld` command line tool is used to download a _loadable_ onto SIMATIC PLCs.

## Prerequisites

[See here](/docs/get-started/prerequisites)

## Command Line Interface

**_Synopsis_**

```sh
sld -t targetIP -i loadable_directory [-r] [--no-verification] [--default-server-interface] [-l log_level] --accept-security-disclaimer
```

**_Description_**

- **_--targetIP, -t_** The ip parameter specifies the IP-address of the SIMATIC PLC for download.
- **_--input, -i_** The loadable parameter specifies the folder containing the loadable data generated through compilation.
- **_--restart, -r_** The restart flag indicates that the SIMATIC PLC should be set to the RUN state after download. This flag is ignored, if the switch on the PLC is in STOP position.
- **_--no-verification_** This flag indicates that the loadable verification should not be checked; set this flag if you edited the loadable files after compilation. Default: false.
- **_--default-server-interface_** This flag enables the OPC/UA server on the SIMATIC PLC; this allows data access to variables. See additional notes below. Default: false.
- **_--log, -l_** The log parameter controls the output verbosity of the loader. Defaults to Information. Supported values: Trace, Debug, Information, Warning, Error, Critical, None.
- **--accept-security-disclaimer** This flag needs to be set to confirm that you have read and understood the security disclaimer.
- **_-p|--password_** Add a legitimation password for the PLC (e.g. \"-p:MY_PASSWORD\"), note that this password is submitted in clear text. If you use the flag without value (e.g. \"-p\") a secure prompt will appear and you can enter the password in a safe way.
- **_-C|--certificate_** The file containing the public key (exported from TIA Portal) for communicating with the PLC. For more information check [certificate handling](/docs/hardware/engineering/certificate)

## Example

```sh
sld -t 192.168.0.1 -i d:\ax-builds\example --accept-security-disclaimer
```

Downloads the files from `d:\ax-builds\example` folder to the plc with ip address `192.168.0.1`.

## Notes for Default OPC/UA Server Interface

When the command line option **_--default-server-interface_** is set, **all** variables of the PLC program are accessible
by an OPC/UA client in the PLC via the OPC/UA standard interface _without_ any restrictions.

This is an early intermediate step to enable the use of OPC/UA for the communication between the PLC and OPC/UA clients.
The option will be extended in a later release of the AX SDK by support of server interfaces defined with companion specs.

> DANGER
>
> In this release **all** variables of the PLC program are readable and writable by any OPC/UA client.
> No restrictions can be applied. So use this option carefully and only in a test environment.

> TIP
>
> Enable the OPC/UA server in the HW configuration in the TIA Portal project and download the HW configuration to the PLC.

> TIP
>
> The nesting level of types and classes is limited with this option to 8 levels. If the limit is violated the download will fail.
