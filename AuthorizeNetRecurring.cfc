<!--- written by Ryan Stille, CF WebTools.
http://www.stillnetstudios.com
http://www.cfwebtools.com
Please send me feedback at ryan@cfwebtools.com.  Will try to add more documentation soon.

Copyright 2007 Ryan Stille / CFWebTools

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
   
--->

<cfcomponent displayname="AuthorizeNetRecurring.cfc" hint="Version .3. Provides Authorize.net recurring billing functionality">

	<cffunction name="init" access="public" returntype="AuthorizeNetRecurring">
		<cfargument name="loginname" required="Yes" type="string" />
		<cfargument name="transactionKey" required="Yes" type="string" />
		<cfargument name="mode" type="string" default="test" /> <!---  should be either 'test' or 'live' --->
		
		<cfset variables.loginname = Arguments.loginname />
		<cfset variables.transactionKey = Arguments.transactionKey />
		<cfset variables.mode = Arguments.mode />
		
		<cfif variables.mode EQ "live">
			<cfset variables.apiurl = "https://api.authorize.net/xml/v1/request.api" />	
		<cfelse>
			<cfset variables.apiurl = "https://apitest.authorize.net/xml/v1/request.api" />
		</cfif>
		
		<cfreturn this />
	
	</cffunction>
	
	<cffunction name="createSubscription" access="public" displayname="Creates a recurring subscription">
		<!--- put differences between create and update methods first  --->
		<cfargument name="startDate" type="date" default="#DateFormat(Now(),"yyyy-mm-dd")#" />
		<cfargument name="paymentIntervalLength" type="numeric" default="1" />
		<cfargument name="paymentIntervalUnit" type="string" default="months" />
		<cfargument name="totalOccurrences" type="numeric" default="36" />
		<cfargument name="amount" type="numeric" required="Yes" />
		<cfargument name="billFirstName" type="string" required="Yes" />
		<cfargument name="billLastName" type="string" required="Yes" />
		<cfargument name="chargetype" type="string" default="cc" />
		
		<!--- the rest should be the same between the two methods --->
		<cfargument name="refID" type="string" required="No" />
		<cfargument name="subscriptionName" type="string" required="No" />
		<cfargument name="trialOccurrences" type="numeric" required="No" />
		<cfargument name="trialAmount" type="numeric" required="No" />
		<cfargument name="cardNumber" type="string" required="No" />
		<cfargument name="expirationDate" type="string" required="No"/>
		<cfargument name="accountType" type="string" required="No"/>
		<cfargument name="routingNumber" type="numeric" required="No"/>
		<cfargument name="accountNumber" type="numeric" required="No"/>
		<cfargument name="nameOnAccount" type="string" required="No" />
		<cfargument name="bankName" type="string" required="No" />
		<cfargument name="echeckType" type="string" required="No" />
		<cfargument name="invoiceNumber" type="string" required="No" />
		<cfargument name="orderDescription" type="string" required="No" />
		
		<cfargument name="customerType" type="string" required="No" />
		<cfargument name="customerId" type="string" required="No" />
		<cfargument name="customerEmail" type="string" required="No" />
		<cfargument name="customerPhone" type="string" required="No" />
		<cfargument name="customerFax" type="string" required="No" />
		
		<cfargument name="billCompany" type="string" required="No" />
		<cfargument name="billAddress" type="string" required="No" />
		<cfargument name="billCity" type="string" required="No" />
		<cfargument name="billState" type="string" required="No" />
		<cfargument name="billZip" type="string" required="No" />
		<cfargument name="billCountry" type="string" required="No" />
		
		<cfargument name="shipFirstName" type="string" required="No" />
		<cfargument name="shipLastName" type="string" required="No" />
		<cfargument name="shipCompany" type="string" required="No" />
		<cfargument name="shipAddress" type="string" required="No" />
		<cfargument name="shipCity" type="string" required="No" />
		<cfargument name="shipState" type="string" required="No" />
		<cfargument name="shipZip" type="string" required="No" />
		<cfargument name="shipCountry" type="string" required="No" />
		
		<cfreturn sendRequest(createXML(ArgumentCollection = Arguments, requestType = "ARBCreateSubscriptionRequest"))/>	
		
	</cffunction>

	
	<cffunction name="updateSubscription" access="public" displayname="Updates an existing recurring subscription">
		<!--- put differences between create and update methods first  --->
		<cfargument name="subscriptionId" type="numeric" required="Yes" />
		<cfargument name="startDate" type="date" required="No" />
		<cfargument name="paymentIntervalLength" type="numeric" required="No" />
		<cfargument name="paymentIntervalUnit" type="string" required="No" />
		<cfargument name="totalOccurrences" type="numeric" required="No" />
		<cfargument name="amount" type="numeric" required="No" />
		<cfargument name="billFirstName" type="string" required="No" />
		<cfargument name="billLastName" type="string" required="No" />
		<cfargument name="chargetype" type="string" default="" />
		
		<!--- the rest should be the same between the two methods --->
		
		<cfargument name="refID" type="string" required="No" />
		<cfargument name="subscriptionName" type="string" required="No" />
		<cfargument name="trialOccurrences" type="numeric" required="No" />
		<cfargument name="trialAmount" type="numeric" required="No" />
		<cfargument name="cardNumber" type="string" required="No" />
		<cfargument name="expirationDate" type="string" required="No"/>
		<cfargument name="accountType" type="string" required="No"/>
		<cfargument name="routingNumber" type="numeric" required="No"/>
		<cfargument name="accountNumber" type="numeric" required="No"/>
		<cfargument name="nameOnAccount" type="string" required="No" />
		<cfargument name="bankName" type="string" required="No" />
		<cfargument name="echeckType" type="string" required="No" />
		<cfargument name="invoiceNumber" type="string" required="No" />
		<cfargument name="orderDescription" type="string" required="No" />
		
		<cfargument name="customerType" type="string" required="No" />
		<cfargument name="customerId" type="string" required="No" />
		<cfargument name="customerEmail" type="string" required="No" />
		<cfargument name="customerPhone" type="string" required="No" />
		<cfargument name="customerFax" type="string" required="No" />
		
		<cfargument name="billCompany" type="string" required="No" />
		<cfargument name="billAddress" type="string" required="No" />
		<cfargument name="billCity" type="string" required="No" />
		<cfargument name="billState" type="string" required="No" />
		<cfargument name="billZip" type="string" required="No" />
		<cfargument name="billCountry" type="string" required="No" />
		
		<cfargument name="shipFirstName" type="string" required="No" />
		<cfargument name="shipLastName" type="string" required="No" />
		<cfargument name="shipCompany" type="string" required="No" />
		<cfargument name="shipAddress" type="string" required="No" />
		<cfargument name="shipCity" type="string" required="No" />
		<cfargument name="shipState" type="string" required="No" />
		<cfargument name="shipZip" type="string" required="No" />
		<cfargument name="shipCountry" type="string" required="No" />
			
		<cfreturn sendRequest(createXML(ArgumentCollection = Arguments,requestType = "ARBUpdateSubscriptionRequest"))/>	
		
	</cffunction>

	<cffunction name="cancelSubscription" access="public" displayname="Cancels a recurring subscription">
		<cfargument name="subscriptionId" type="numeric" required="Yes" />
		<cfargument name="refID" type="string" required="No" />
		
		<cfset var xml = "" />
		<cfset var tmpxml = "" />
		
		<cfsavecontent variable="xml">
		<cfoutput>
		<?xml version="1.0" encoding="utf-8"?>
		<ARBCancelSubscriptionRequest xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">
		<merchantAuthentication>
		<name>#variables.loginname#</name>
		<transactionKey>#variables.transactionKey#</transactionKey>
		</merchantAuthentication>
		</cfoutput>
		</cfsavecontent>

		<cfif IsDefined("Arguments.refId") AND Len(Arguments.refId)>
			<cfset xml = xml & "<refId>#Arguments.refId#</refId>#Chr(10)#" />
		</cfif>
		
		<cfset xml = xml & "<subscriptionId>#Arguments.subscriptionId#</subscriptionId>#Chr(10)#" />
		<cfset xml = xml & "</ARBCancelSubscriptionRequest>#Chr(10)#" />
		
		<cfreturn sendRequest(Trim(xml))>
		
	</cffunction>
	
	<cffunction name="createXML" hint="Generates the XML used for creating/updating" access="private" returntype="string">
		<cfset var xml = "" />
		<cfset var tmpxml = "" />
		<cfset var i = 0>
		
		<!--- clean up the credit card number, if exists --->
		<cfif IsDefined("Arguments.cardnumber") AND Len(Arguments.cardnumber)>
			<cfset Arguments.cardnumber = ReReplace(Arguments.cardnumber,"\D","","all")>
		</cfif>

		<!--- escape any bad chars in any of our arguments --->
		<cfloop from="1" to="#ArrayLen(Arguments)#" index="i">
			<cfset ArraySet(Arguments,i,i,XMLFormat(Arguments[i]))>
		</cfloop>

		<cfsavecontent variable="xml">
		<cfoutput>
		<?xml version="1.0" encoding="utf-8"?>
		<#Arguments.requestType# xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">
		<merchantAuthentication>
		<name>#variables.loginname#</name>
		<transactionKey>#variables.transactionKey#</transactionKey>
		</merchantAuthentication>
		</cfoutput>
		</cfsavecontent>
		
		<cfif IsDefined("Arguments.refId") AND Len(Arguments.refId)>
			<cfset xml = xml & "<refId>#Arguments.refId#</refId>#Chr(10)#" />
		</cfif>
		
		<!--- This is only used for update/cancel requests --->
		<cfif IsDefined("Arguments.subscriptionId") AND Len(Arguments.subscriptionId)>
			<cfset xml = xml & "<subscriptionId>#Arguments.subscriptionId#</subscriptionId>#Chr(10)#" />
		</cfif>
		
		<cfset xml = xml & "<subscription>#Chr(10)#">
		
		<cfif IsDefined("Arguments.subscriptionName") AND Len(Arguments.subscriptionName)>
			<cfset xml = xml & "<name>#Arguments.subscriptionName#</name>#Chr(10)#" />
		</cfif>
		
		<cfif IsDefined("Arguments.paymentIntervalLength") AND Len(Arguments.paymentIntervalLength)
			OR IsDefined("Arguments.paymentIntervalUnit") AND Len(Arguments.paymentIntervalUnit)
			OR IsDefined("Arguments.startDate") AND Len(Arguments.startDate)
			OR IsDefined("Arguments.trialOccurrences") AND Len(Arguments.trialOccurrences)
			OR IsDefined("Arguments.totalOccurrences") AND Len(Arguments.totalOccurrences)>
			<cfset xml = xml & "<paymentSchedule>#Chr(10)#" />
		
			<cfif IsDefined("Arguments.paymentIntervalLength") AND Len(Arguments.paymentIntervalLength)
				OR IsDefined("Arguments.paymentIntervalUnit") AND Len(Arguments.paymentIntervalUnit)>
				<cfset xml = xml & "<interval>#Chr(10)#" />
				<cfif IsDefined("Arguments.paymentIntervalLength") AND Len(Arguments.paymentIntervalLength)>
					<cfset xml = xml & "<length>#Arguments.paymentIntervalLength#</length>#Chr(10)#" />
				</cfif>
				<cfif IsDefined("Arguments.paymentIntervalUnit") AND Len(Arguments.paymentIntervalUnit)>
					<cfset xml = xml & "<unit>#Arguments.paymentIntervalUnit#</unit>#Chr(10)#" />
				</cfif>
				<cfset xml = xml & "</interval>#Chr(10)#" />
			</cfif>
			
			<cfif IsDefined("Arguments.startDate") AND Len(Arguments.startDate)>
				<cfset xml = xml & "<startDate>#Arguments.startDate#</startDate>#Chr(10)#" />
			</cfif>
			<cfif IsDefined("Arguments.totalOccurrences") AND Len(Arguments.totalOccurrences)>
				<cfset xml = xml & "<totalOccurrences>#Arguments.totalOccurrences#</totalOccurrences>#Chr(10)#" />
			</cfif>	
			<cfif IsDefined("Arguments.trialOccurrences") AND Len(Arguments.trialOccurrences)>
				<cfset xml = xml & "<trialOccurrences>#Arguments.trialOccurrences#</trialOccurrences>#Chr(10)#" />
			</cfif>
						
			<cfset xml = xml & "</paymentSchedule>#Chr(10)#" />
		</cfif>
		
		<cfif IsDefined("Arguments.amount") AND Len(Arguments.amount)>
			<cfset xml = xml & "<amount>#Arguments.amount#</amount>" />
		</cfif>
		
		<cfif IsDefined("Arguments.trialAmount") AND Len(Arguments.trialAmount)>
			<cfset xml = xml & "<trialAmount>#Arguments.trialAmount#</trialAmount>" />
		</cfif>

		<cfif IsDefined("Arguments.chargeType") AND Arguments.chargeType EQ "cc">
			<cfsavecontent variable="tmpxml">
			<cfoutput>
			<payment>
			<creditCard>
			<cardNumber>#Arguments.cardNumber#</cardNumber>
			<expirationDate>#Arguments.expirationDate#</expirationDate>
			</creditCard>
			</payment>
			</cfoutput>
			</cfsavecontent>
		<cfelseif IsDefined("Arguments.chargeType") AND Arguments.chargeType EQ "etf">
			<cfsavecontent variable="tmpxml">
			<cfoutput>
			<payment>
			<bankAccount>
			<accountType>#Arguments.accountType#</accountType>
			<routingNumber>#Arguments.routingNumber#</routingNumber>
			<accountNumber>#Arguments.accountNumber#</accountNumber>
			<nameOnAccount>#Arguments.nameOnAccount#</nameOnAccount>
			<echeckType>#Arguments.echeckType#</echeckType>
			<bankName>#Arguments.bankName#</bankName>
			</bankAccount>
			</payment>
			</cfoutput>
			</cfsavecontent>
		</cfif>

		<cfset xml = xml & tmpxml>
				
		<cfif IsDefined("Arguments.invoiceNumber") AND Len(Arguments.invoiceNumber)
			OR IsDefined("Arguments.orderDescription") AND Len(Arguments.orderDescription)>
			<cfset xml = xml & "<order>#Chr(10)#" />
			<cfif IsDefined("Arguments.invoiceNumber") AND Len(Arguments.invoiceNumber)>
				<cfset xml = xml & "<invoiceNumber>#Arguments.invoiceNumber#</invoiceNumber>#Chr(10)#" />
			</cfif>
			<cfif IsDefined("Arguments.orderDescription") AND Len(Arguments.orderDescription)>
				<cfset xml = xml & "<description>#Arguments.orderDescription#</description>#Chr(10)#" />
			</cfif>
			<cfset xml = xml & "</order>#Chr(10)#" />
		</cfif>
		
		<cfif IsDefined("Arguments.customerType") AND Len(Arguments.customerType)
			OR IsDefined("Arguments.customerId") AND Len(Arguments.customerId)
			OR IsDefined("Arguments.customerEmail") AND Len(Arguments.customerEmail)
			OR IsDefined("Arguments.customerPhone") AND Len(Arguments.customerPhone)
			OR IsDefined("Arguments.customerFax") AND Len(Arguments.customerFax)>
			<cfset xml = xml & "<customer>#Chr(10)#" />
			
			<cfif IsDefined("Arguments.customerType") AND Len(Arguments.customerType)>
				<cfset xml = xml & "<type>#Arguments.customerType#</type>#Chr(10)#" />
			</cfif>
			<cfif IsDefined("Arguments.customerId") AND Len(Arguments.customerId)>
				<cfset xml = xml & "<id>#Arguments.customerId#</id>#Chr(10)#" />
			</cfif>
			<cfif IsDefined("Arguments.customerEmail") AND Len(Arguments.customerEmail)>
				<cfset xml = xml & "<email>#Arguments.customerEmail#</email>#Chr(10)#" />
			</cfif>
			<cfif IsDefined("Arguments.customerPhone") AND Len(Arguments.customerPhone)>
				<cfset xml = xml & "<phoneNumber>#Arguments.customerPhone#</phoneNumber>#Chr(10)#" />
			</cfif>
			<cfif IsDefined("Arguments.customerFax") AND Len(Arguments.customerFax)>
				<cfset xml = xml & "<faxNumber>#Arguments.customerFax#</faxNumber>#Chr(10)#" />
			</cfif>
			
			<cfset xml = xml & "</customer>#Chr(10)#" />
		</cfif>

		<cfif IsDefined("Arguments.billFirstName") AND Len(Arguments.billFirstName)
			OR IsDefined("Arguments.billLastName") AND Len(Arguments.billLastName)
			OR IsDefined("Arguments.billCompany") AND Len(Arguments.billCompany)
			OR IsDefined("Arguments.billAddresss") AND Len(Arguments.billAddress)
			OR IsDefined("Arguments.billCity") AND Len(Arguments.billCity)
			OR IsDefined("Arguments.billState") AND Len(Arguments.billState)
			OR IsDefined("Arguments.billZip") AND Len(Arguments.billZip)
			OR IsDefined("Arguments.billCountry") AND Len(Arguments.billCountry)>
		
			<cfset xml = xml & "<billTo>#Chr(10)#" />
			
			<cfif IsDefined("Arguments.billFirstName") AND Len(Arguments.billFirstName)>
				<cfset xml = xml & "<firstName>#Arguments.billFirstName#</firstName>#Chr(10)#" />
			</cfif>
			<cfif IsDefined("Arguments.billLastName") AND Len(Arguments.billLastName)>
				<cfset xml = xml & "<lastName>#Arguments.billLastName#</lastName>#Chr(10)#" />
			</cfif>
			<cfif IsDefined("Arguments.billCompany") AND Len(Arguments.billCompany)>
				<cfset xml = xml & "<company>#Arguments.billCompany#</company>#Chr(10)#" />
			</cfif>
			<cfif IsDefined("Arguments.billAddress") AND Len(Arguments.billAddress)>
				<cfset xml = xml & "<address>#Arguments.billAddress#</address>#Chr(10)#" />
			</cfif>
			<cfif IsDefined("Arguments.billCity") AND Len(Arguments.billCity)>
				<cfset xml = xml & "<city>#Arguments.billCity#</city>#Chr(10)#" />
			</cfif>
			<cfif IsDefined("Arguments.billState") AND Len(Arguments.billState)>
				<cfset xml = xml & "<state>#Arguments.billState#</state>#Chr(10)#" />
			</cfif>
			<cfif IsDefined("Arguments.billZip") AND Len(Arguments.billZip)>
				<cfset xml = xml & "<zip>#Arguments.billZip#</zip>#Chr(10)#" />
			</cfif>
			<cfif IsDefined("Arguments.billCountry") AND Len(Arguments.billCountry)>
				<cfset xml = xml & "<country>#Arguments.billCountry#</country>#Chr(10)#" />
			</cfif>
			
			<cfset xml = xml & "</billTo>#Chr(10)#" />
		</cfif>

		<cfif IsDefined("Arguments.shipFirstName") AND Len(Arguments.shipFirstName)
			OR IsDefined("Arguments.shipLastName") AND Len(Arguments.shipLastName)
			OR IsDefined("Arguments.shipCompany") AND Len(Arguments.shipCompany)
			OR IsDefined("Arguments.shipAddress") AND Len(Arguments.shipAddress)
			OR IsDefined("Arguments.shipCity") AND Len(Arguments.shipCity)
			OR IsDefined("Arguments.shipState") AND Len(Arguments.shipState)
			OR IsDefined("Arguments.shipZip") AND Len(Arguments.shipZip)
			OR IsDefined("Arguments.shipCountry") AND Len(Arguments.shipCountry)>
			<cfset xml = xml & "<shipTo>#Chr(10)#" />
			
			<cfif IsDefined("Arguments.shipFirstName") AND Len(Arguments.shipFirstName)>
				<cfset xml = xml & "<firstName>#Arguments.shipFirstName#</firstName>#Chr(10)#" />
			</cfif>
			<cfif IsDefined("Arguments.shipLastName") AND Len(Arguments.shipLastName)>
				<cfset xml = xml & "<lastName>#Arguments.shipLastName#</lastName>#Chr(10)#" />
			</cfif>
			<cfif IsDefined("Arguments.shipCompany") AND Len(Arguments.shipCompany)>
				<cfset xml = xml & "<company>#Arguments.shipCompany#</company>#Chr(10)#" />
			</cfif>
			<cfif IsDefined("Arguments.shipAddress") AND Len(Arguments.shipAddress)>
				<cfset xml = xml & "<address>#Arguments.shipAddress#</address>#Chr(10)#" />
			</cfif>
			<cfif IsDefined("Arguments.shipCity") AND Len(Arguments.shipCity)>
				<cfset xml = xml & "<city>#Arguments.shipCity#</city>#Chr(10)#" />
			</cfif>
			<cfif IsDefined("Arguments.shipState") AND Len(Arguments.shipState)>
				<cfset xml = xml & "<state>#Arguments.shipState#</state>#Chr(10)#" />
			</cfif>
			<cfif IsDefined("Arguments.shipZip") AND Len(Arguments.shipZip)>
				<cfset xml = xml & "<zip>#Arguments.shipZip#</zip>#Chr(10)#" />
			</cfif>
			<cfif IsDefined("Arguments.shipCountry") AND Len(Arguments.shipCountry)>
				<cfset xml = xml & "<country>#Arguments.shipCountry#</country>#Chr(10)#" />
			</cfif>
			
			<cfset xml = xml & "</shipTo>#Chr(10)#" />
		</cfif>
		
		<cfset xml = xml & "</subscription>#Chr(10)#" />
		<cfset xml = xml & "</#Arguments.requestType#>#Chr(10)#" />
		
		<cfreturn Trim(xml)>
	
	</cffunction>
	
	<cffunction name="sendRequest" access="private" hint="Sends the http request to Authorize.net">
		<cfargument name="xmlString" required="Yes" type="string"/>
		
		<cfset var returnedXML = ""/>
		<cfset var xmldoc = ""/>
		<cfset var retStruct = StructNew()/>
		
		<cfhttp url="#Variables.apiurl#" method="post" charset="UTF-8">
		<cfhttpparam type="HEADER" name="content-type" value="text/xml"/>
		<cfhttpparam type="BODY" value="#Arguments.xmlString#"/>
		</cfhttp>
		
		<cfset returnedXML = cfhttp.fileContent/>
	
		<!--- remove the BOM (byte order mark) from the resulting content, if it exists --->
		<cfif Asc(Left(cfhttp.fileContent,1)) EQ 65279>
			<cfset returnedXML = Right(returnedXML,Len(returnedXML)-1)/>
		</cfif> 
		
		<cftry>
			<!--- will also return the sent orignal xml in case they want to do anything else with it --->
			<cfset retStruct.returnedXML = returnedXML/>
			
			<cfset xmldoc = XMLParse(returnedXML)/>
			
			<cfset retStruct.resultCode = xmldoc.Xmlroot.messages.resultCode.XmlText/>
			<cfset retStruct.messageText = xmldoc.Xmlroot.messages.message.text.XmlText/>
			<cfset retStruct.messageCode = xmldoc.Xmlroot.messages.message.code.XmlText/>
			
			<cfif IsDefined("xmldoc.Xmlroot.subscriptionId")>
				<cfset retStruct.subscriptionId = xmldoc.Xmlroot.subscriptionId.XmlText/>
			</cfif>
			
			<cfif IsDefined("xmldoc.Xmlroot.refId")>
				<cfset retStruct.refId = xmldoc.Xmlroot.refId.XmlText/>
			</cfif>
			
			<cfif xmldoc.Xmlroot.messages.resultCode.XmlText NEQ "ok">
				<cfset retStruct.error = true/>
			<cfelse>
				<cfset retStruct.error = false/>
			</cfif>
			
			<cfcatch type="any">
				<cfset retStruct.error = True/>
				<cfset retStruct.resultCode = ""/>
				<cfset retStruct.messageCode = ""/>
				<cfset retStruct.messageText = "CF error processing XML"/>
				<cfset retStruct.cfcatch_message = cfcatch.message/>
				<cfset retStruct.cfcatch_detail = cfcatch.detail/>
			</cfcatch>
		</cftry>

		<cfreturn retStruct />
	</cffunction>

</cfcomponent>
