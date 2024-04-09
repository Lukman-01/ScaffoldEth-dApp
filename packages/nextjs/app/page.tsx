"use client";

import Link from "next/link";
import type { NextPage } from "next";
import { useAccount } from "wagmi";
import { BugAntIcon, MagnifyingGlassIcon } from "@heroicons/react/24/outline";
import { Address } from "~~/components/scaffold-eth";

const Home: NextPage = () => {
  const { address: connectedAddress } = useAccount();

  interface Service {
    title: string;
    description: string;
  }
  
  const services: Service[] = [
    {
      title: 'Supply Chain Tracking',
      description: 'Effortlessly track the journey of your products from source to destination.',
    },
    {
      title: 'Supply Chain Transparency',
      description: 'Ensure transparency throughout the supply chain with a shared ledger.',
    },
    {
      title: 'Product Traceability',
      description: 'Trace the origin and history of products to maintain quality and authenticity.',
    },
    {
      title: 'Data Consistency and Security',
      description: 'Ensure data consistency and security through blockchain technology.',
    },
    {
      title: 'Standardized Status Tracking',
      description: 'Track the status of products or services in a unified platform.',
    },
    {
      title: 'Consumer Confidence',
      description: 'Enhance consumer trust with transparent supply chain tracking and verification.',
    },
  ];

  return (
    <>
      <div className="flex items-center flex-col flex-grow ">
        <div>
          <div className="flex flex-col justify-center items-center h-screen">
            <div className='w-3/5 mx-auto'>
              <h1 className="text-center text-2xl md:text-4xl lg:text-6xl font-bold  mb-8">
                Welcome to SupdApp
              </h1>
              <p className="text-xl md:text-2xl lg:text-3xl text-center mb-12">
              SupdApp is a decentralized application that utilizes blockchain technology to enhance transparency, traceability, and efficiency in the management of supply chain processes.
              </p>
              <p className="text-xl md:text-2xl lg:text-3xl text-center mb-12">
                Track and manage your supply chain with ease.
              </p>
            </div>
            <div className="flex justify-center items-center">
            <p className="font-medium">Connected Address:</p>
            <Address address={connectedAddress} />
            </div>
          </div>
          <div>
            <div className='w-4/5 mx-auto'>
              <h1 className="text-center text-2xl md:text-4xl lg:text-6xl text-white mb-8 text-slate-600 pt-10">
                Our App Features
              </h1>
            </div>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 w-4/5 mx-auto pt-10 pb-10">
              {services.map((service, index) => (
                <div
                  key={index}
                  className="bg-white rounded-lg shadow-lg p-6 text-center"
                >
                  <h3 className="text-2xl font-bold text-gray-800 ">{service.title}</h3>
                  <p className="text-gray-600">{service.description}</p>
                </div>
              ))}
            </div>
          </div>
        </div>

        <div className="flex-grow bg-base-300 w-full mt-1 px-8 py-12">
          <div className="flex justify-center items-center gap-12 flex-col sm:flex-row">
            <div className="flex flex-col bg-base-100 px-10 py-10 text-center items-center max-w-xs rounded-3xl">
              <BugAntIcon className="h-8 w-8 fill-secondary" />
              <p>
                Tinker with your smart contract using the{" "}
                <Link href="/debug" passHref className="link">
                  Interact With Contracts
                </Link>{" "}
                tab.
              </p>
            </div>
            <div className="flex flex-col bg-base-100 px-10 py-10 text-center items-center max-w-xs rounded-3xl">
              <MagnifyingGlassIcon className="h-8 w-8 fill-secondary" />
              <p>
                Explore your local transactions with the{" "}
                <Link href="/blockexplorer" passHref className="link">
                  Block Explorer
                </Link>{" "}
                tab.
              </p>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default Home;
