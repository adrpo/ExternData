#if !defined(ED_XMLFILE_C)
#define ED_XMLFILE_C

#if defined(__gnu_linux__)
#define _GNU_SOURCE 1
#endif

#include <string.h>
#if defined(_MSC_VER)
#define strdup _strdup
#endif
#include "ED_locale.h"
#include "bsxml.h"
#include "ModelicaUtilities.h"
#include "../Include/ED_XMLFile.h"

typedef struct {
	char* fileName;
	XmlNodeRef root;
	ED_LOCALE_TYPE loc;
} XMLFile;

void* ED_createXML(const char* fileName) {
	XMLFile* xml = NULL;
	XmlParser xmlParser;
	XmlNodeRef root = XmlParser_parse_file(&xmlParser, fileName);
	if (root == NULL) {
		ModelicaFormatError("Cannot parse file \"%s\"\n", fileName);
	}
	xml = (XMLFile*)malloc(sizeof(XMLFile));
	if (xml != NULL) {
		xml->fileName = strdup(fileName);
		if (xml->fileName == NULL) {
			XmlNode_deleteTree(root);
			free(xml);
			ModelicaError("Memory allocation error\n");
			return NULL;
		}
		xml->loc = ED_INIT_LOCALE;
		xml->root = root;
	}
	else {
		ModelicaError("Memory allocation error\n");
	}
	return xml;
}

void ED_destroyXML(void* _xml)
{
	XMLFile* xml = (XMLFile*)_xml;
	if (xml != NULL) {
		if (xml->fileName != NULL) {
			free(xml->fileName);
		}
		XmlNode_deleteTree(xml->root);
		ED_FREE_LOCALE(xml->loc);
		free(xml);
	}
}

static char* findValue(XmlNodeRef* root, const char* varName, const char* fileName)
{
	char* token = NULL;
	char* buf = strdup(varName);
	if (buf != NULL) {
		int elementError = 0;
		token = strtok(buf, ".");
		if (token == NULL) {
			elementError = 1;
		}
		while (token != NULL && elementError == 0) {
			int i;
			int foundToken = 0;
			for (i = 0; i < XmlNode_getChildCount(*root); i++) {
				XmlNodeRef child = XmlNode_getChild(*root, i);
				if (XmlNode_isTag(child, token)) {
					*root = child;
					token = strtok(NULL, ".");
					foundToken = 1;
					break;
				}
			}
			if (foundToken == 0) {
				elementError = 1;
			}
		}
		free(buf);
		if (elementError == 1) {
			ModelicaFormatError("Error in line %i when reading element \"%s\" from file \"%s\"\n",
				XmlNode_getLine(*root), varName, fileName);
		}
		XmlNode_getValue(*root, &token);
	}
	else {
		ModelicaError("Memory allocation error\n");
	}
	return token;
}

double ED_getDoubleFromXML(void* _xml, const char* varName)
{
	double ret = 0.;
	XMLFile* xml = (XMLFile*)_xml;
	if (xml != NULL) {
		XmlNodeRef root = xml->root;
		char* token = findValue(&root, varName, xml->fileName);
		if (token != NULL) {
			if (ED_strtod(token, xml->loc, &ret)) {
				ModelicaFormatError("Error in line %i when reading double value \"%s\" from file \"%s\"\n",
					XmlNode_getLine(root), token, xml->fileName);
			}
		}
		else {
			ModelicaFormatError("Error in line %i when reading double value from file \"%s\"\n",
				XmlNode_getLine(root), xml->fileName);
		}
	}
	return ret;
}

const char* ED_getStringFromXML(void* _xml, const char* varName)
{
	XMLFile* xml = (XMLFile*)_xml;
	if (xml != NULL) {
		XmlNodeRef root = xml->root;
		char* token = findValue(&root, varName, xml->fileName);
		if (token != NULL) {
			char* ret = ModelicaAllocateString(strlen(token));
			strcpy(ret, token);
			return (const char*)ret;
		}
		else {
			ModelicaFormatError("Error in line %i when reading value from file \"%s\"\n",
				XmlNode_getLine(root), xml->fileName);
		}
	}
	return "";
}

int ED_getIntFromXML(void* _xml, const char* varName)
{
	int ret = 0;
	XMLFile* xml = (XMLFile*)_xml;
	if (xml != NULL) {
		XmlNodeRef root = xml->root;
		char* token = findValue(&root, varName, xml->fileName);
		if (token != NULL) {
			if (ED_strtoi(token, xml->loc, &ret)) {
				ModelicaFormatError("Error in line %i when reading int value \"%s\" from file \"%s\"\n",
					XmlNode_getLine(root), token, xml->fileName);
			}
		}
		else {
			ModelicaFormatError("Error in line %i when reading int value from file \"%s\"\n",
				XmlNode_getLine(root), xml->fileName);
		}
	}
	return ret;
}

void ED_getDoubleArray1DFromXML(void* _xml, const char* varName, double* a, size_t n)
{
	XMLFile* xml = (XMLFile*)_xml;
	if (xml != NULL) {
		XmlNodeRef root = xml->root;
		char* token = findValue(&root, varName, xml->fileName);
		while (token == NULL && XmlNode_getChildCount(root) > 0) {
			/* Try children if root is empty */
			root = XmlNode_getChild(root, 0);
			XmlNode_getValue(root, &token);
		}
		if (token != NULL) {
			char* buf = strdup(token);
			if (buf != NULL) {
				size_t i = 0;
				int iSibling = 0;
				XmlNodeRef parent = XmlNode_getParent(root);
				int nSiblings = XmlNode_getChildCount(parent);
				int line = XmlNode_getLine(root);
				token = strtok(buf, "[]{},; \t");
				while (i < n) {
					if (token != NULL) {
						if (ED_strtod(token, xml->loc, &a[i++])) {
							free(buf);
							ModelicaFormatError("Error in line %i when reading double value \"%s\" from file \"%s\"\n",
								line, token, xml->fileName);
							return;
						}
						token = strtok(NULL, "[]{},; \t");
					}
					else if (++iSibling < nSiblings) {
						/* Retrieve value from next sibling */
						XmlNodeRef child = XmlNode_getChild(parent, iSibling);
						if (XmlNode_isTag(child, XmlNode_getTag(root))) {
							XmlNode_getValue(child, &token);
							line = XmlNode_getLine(child);
							free(buf);
							if (token != NULL) {
								buf = strdup(token);
								if (buf != NULL) {
									token = strtok(buf, "[]{},; \t");
								}
								else {
									ModelicaError("Memory allocation error\n");
									return;
								}
							}
							else {
								ModelicaFormatError("Error in line %i when reading empty (%lu.) element \"%s\" from file \"%s\"\n",
									line, (unsigned long)(iSibling + 1), varName, xml->fileName);
								return;
							}
						}
					}
					else {
						/* Error: token is NULL and no (more) siblings */
						free(buf);
						if (nSiblings > 1) {
							XmlNodeRef child;
							child = XmlNode_getChild(parent, nSiblings - 1);
							line = XmlNode_getLine(child);
							ModelicaFormatError("Error after line %i when reading nonexistent (%lu.) element \"%s\" from file \"%s\"\n",
								line, (unsigned long)(iSibling + 1), varName, xml->fileName);
						}
						else {
							ModelicaFormatError("Error in line %i when reading %lu double values from file \"%s\"\n",
								line, (unsigned long)n, xml->fileName);
						}
						return;
					}
				}
				free(buf);
			}
			else {
				ModelicaError("Memory allocation error\n");
			}
		}
		else {
			ModelicaFormatError("Error in line %i when reading empty element \"%s\" from file \"%s\"\n",
				XmlNode_getLine(root), varName, xml->fileName);
		}
	}
}

void ED_getDoubleArray2DFromXML(void* _xml, const char* varName, double* a, size_t m, size_t n)
{
	ED_getDoubleArray1DFromXML(_xml, varName, a, m*n);
}

#endif
